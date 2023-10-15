locals {
  rg_name = "rg-${var.prefix}-${var.name}"
  bg_name = "bg-${var.prefix}-${var.name}"
  contacts = concat(var.contact_emails, [var.responsible])
}
# Manage resource group
resource "azurerm_resource_group" "rg" {
    name = local.rg_name
    location = var.location
    tags = merge({"eeia" = var.name}, {"responsable" = var.responsible}, var.tags) # Add eeia tag by default
}

# Manage budget
resource "azurerm_consumption_budget_resource_group" "budget" {
    name = local.bg_name
    amount = var.amount
    time_grain = "BillingMonth"
    time_period {
      start_date = format("YYYY-MM-01'T'hh:mm:ssZ",timestamp())
    }
    resource_group_id = azurerm_resource_group.rg.id
    notification {
      threshold = 90  # Warn at 90% consumption threshold
      operator = "GreaterThan"
      contact_emails = local.contacts
    }
    notification {
      threshold = 100   # Warn when forcast says budget is over
      threshold_type = "Forecasted"
      operator = "GreaterThan"
      contact_emails = local.contacts
    }
    lifecycle {
      ignore_changes = [ 
        time_period
       ]
    }
}