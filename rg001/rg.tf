locals {
  rg_name = "rg-${var.prefix}-${var.name}"
  bg_name = "bg-${var.prefix}-${var.name}"
}
# Manage resource group
resource "azurerm_resource_group" "rg" {
    name = local.rg_name
    location = var.location
    tags = merge({"eeia" = var.name}, var.tags) # Add eeia tag by default
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
      contact_emails = var.contact_emails
    }
    notification {
      threshold = 100   # Warn when forcast says budget is over
      threshold_type = "Forecasted"
      operator = "GreaterThan"
      contact_emails = var.contact_emails
    }
    lifecycle {
      ignore_changes = [ 
        time_period
       ]
    }
}