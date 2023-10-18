locals {
  cs_name = "gptkb-${var.name}"
  ca_name = "cog-fr-${var.name}"
}

resource "azurerm_cognitive_account" "cognitive_search_account" {
    name = local.ca_name
    location = var.location
    resource_group_name = var.resource_group_name
    kind = "FormRecognizer"

    sku_name = "S0"

    custom_subdomain_name       = local.ca_name
    dynamic_throttling_enabled  = false
    fqdns                       = []

    tags = var.tags
}

resource "azurerm_search_service" "cognitive_search" {
    name                  = local.cs_name
    resource_group_name   = var.resource_group_name
    location              = var.location
    sku                   = var.sku

    allowed_ips                   = []
    authentication_failure_mode   = "http401WithBearerChallenge"

    identity {
            type         = "SystemAssigned"
        }

    tags = var.tags
}