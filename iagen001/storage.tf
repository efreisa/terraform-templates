locals {
  st_name = "st${var.name}"
  container_name = "content"
}

resource "azurerm_storage_account" "storage_account" {
    name = local.st_name
    resource_group_name = var.resource_group_name
    location = var.location
    account_tier = "Standard"
    account_replication_type = "LRS"

    allow_nested_items_to_be_public = false
    
    tags = var.tags
}

resource "azurerm_storage_container" "container" {
  name = local.container_name
  storage_account_name = local.st_name
}