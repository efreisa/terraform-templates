# Local admin password
resource "random_string" "AVD_local_password" {
  for_each         = toset(var.vm_list)
  length           = 16
  special          = true
  min_special      = 2
  override_special = "*!@#?"
}

# VM network interface
resource "azurerm_network_interface" "vm_nic" {
  for_each            = toset(var.vm_list)
  name                = "${each.key}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name              = "nic${each.key}_config"
    subnet_id                     = azurerm_subnet.vm_snet001.id
    private_ip_address_allocation = "dynamic"
  }

  tags = var.tags
}

# Virtual machine
resource "azurerm_windows_virtual_machine" "vm" {
  for_each              = toset(var.vm_list)
  name = "${each.key}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  network_interface_ids = [azurerm_network_interface.vm_nic[each.key].id]
  provision_vm_agent    = true
  admin_username        = var.local_admin_username
  admin_password        = var.local_admin_password

  os_disk {
    name = "${lower(each.key)}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.vm_nic
  ]
  tags = var.tags
}

# Shutdown at the end of the day
resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm_shutdown" {
  for_each         = toset(var.vm_list)
  virtual_machine_id         = azurerm_windows_virtual_machine.vm[each.key].id
  location           = var.location
  enabled            = true

  daily_recurrence_time = var.shutdown_time
  timezone              = "Romance Standard Time"

  notification_settings {
    enabled         = false
  }

  tags = var.tags
}