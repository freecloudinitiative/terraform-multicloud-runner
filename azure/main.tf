resource "tls_private_key" "ssh" {
  count     = var.ssh_public_key == "" ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_resource_group" "rg" {
  for_each = local.runners
  name     = "${var.resource_group_name}-${each.key}"
  location = each.value.location
}

resource "azurerm_virtual_network" "vnet" {
  for_each            = local.runners
  name                = "${var.instance_name}-${each.key}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name
}

resource "azurerm_subnet" "subnet" {
  for_each             = local.runners
  name                 = "${var.instance_name}-${each.key}-subnet"
  resource_group_name  = azurerm_resource_group.rg[each.key].name
  virtual_network_name = azurerm_virtual_network.vnet[each.key].name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = local.runners
  name                = "${var.instance_name}-${each.key}-nsg"
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.admin_cidrs
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "pip" {
  for_each            = local.runners
  name                = "${var.instance_name}-${each.key}-pip"
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  for_each            = local.runners
  name                = "${var.instance_name}-${each.key}-nic"
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  for_each                  = local.runners
  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

resource "azurerm_linux_virtual_machine" "runner" {
  for_each              = local.runners
  name                  = "${var.instance_name}-${each.key}"
  location              = azurerm_resource_group.rg[each.key].location
  resource_group_name   = azurerm_resource_group.rg[each.key].name
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  size                  = each.value.size
  admin_username        = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = local.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.module}/install_runner.sh.tftpl", {
    github_pat     = var.github_pat
    github_org     = var.github_org
    runners_per_vm = var.runners_per_vm
  }))

  lifecycle {
    ignore_changes = [custom_data]
  }
}
