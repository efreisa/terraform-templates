# Set variables
locals {
  vm_vnet_name = "${var.prefix}-${var.set_name}-vnet"
  vm_snet_name = "${var.prefix}-${var.set_name}-snet-001"
  vm_peering_vmtohub_name = "from_${var.set_name}_to-network-hub"
  vm_peering_hubtovm_name = "from_network-hub_to-${var.set_name}"

  nsg_vm_vnet_name = "${var.prefix}-${var.set_name}-nsg-001"
}

# VM vnet
resource "azurerm_virtual_network" "vnet" {
  name                = local.vm_vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "vm_snet001" {
  name                 = local.vm_snet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes
}

# Hub vnet
data "azurerm_virtual_network" "hub_vnet" {
  name                = var.hub_name
  resource_group_name = var.hub_rg_name
}

# Peering VNETs
resource "azurerm_virtual_network_peering" "vm_to_hub_peer" {
  name                      = local.vm_peering_vmtohub_name
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.hub_vnet.id
  allow_forwarded_traffic   = true
  use_remote_gateways       = true
}

# Peering VNETs
resource "azurerm_virtual_network_peering" "hub_to_vm_peer" {
  name                      = local.vm_peering_hubtovm_name
  resource_group_name       = var.hub_rg_name
  virtual_network_name      = data.azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
}

# Default network rules
resource "azurerm_network_security_group" "nsg-vm-001" {
  name                = local.nsg_vm_vnet_name
  location            = var.local_admin_password
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "DenyInternet"
    priority                   = 400
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "AccesAzureStorage"
    priority                   = 300
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Storage"
  }
}

# Link NSG
resource "azurerm_subnet_network_security_group_association" "nsg-vm" {
  subnet_id                 = azurerm_subnet.vm_snet001.id
  network_security_group_id = azurerm_network_security_group.nsg-vm-001.id
}