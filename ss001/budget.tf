# Current subscription
data "azurerm_subscription" "current" {}

# Subscription budget
resource "azurerm_consumption_budget_subscription" "ss_budget" {
  name            = "${var.prefix}bg-subscription-001"
  subscription_id = data.azurerm_subscription.current.id
  amount          = var.amount
  time_grain  = "Monthly"
  time_period {
    start_date = formatdate("YYYY-MM-01'T'hh:mm:ssZ",timestamp()) //Budget needs to be first day of current month for start
  }
  notification {
    threshold      = 90             // 0-1000
    operator       = "GreaterThan"  // EqualTo, GreaterThan, GreaterThanOrEqualTo
    contact_emails = var.contact_emails
  }
  notification {
    threshold      = 100             // 0-1000
    threshold_type = "Forecasted"
    operator       = "GreaterThan"  // EqualTo, GreaterThan, GreaterThanOrEqualTo
    contact_emails = var.contact_emails
  }
  
  lifecycle {
    ignore_changes = [
      time_period
    ]
  }
}