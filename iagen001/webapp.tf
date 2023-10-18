locals {
  plan_name = "plan-${var.name}"
  webapp_name ="app-backend-${var.name}"
}
resource "azurerm_service_plan" "plan" {
    name = local.plan_name
    location = var.location
    resource_group_name = var.resource_group_name

    os_type = "Linux"
    sku_name ="B1"

    tags = var.tags
}

resource "azurerm_linux_web_app" "webapp" {
    name = local.webapp_name
    location = var.location
    resource_group_name = var.resource_group_name
    service_plan_id = azurerm_service_plan.plan.id
    https_only = true

    site_config {
      app_command_line                        = "python3 -m gunicorn main:app"
      ftps_state                              = "FtpsOnly"
      scm_use_main_ip_restriction             = true
      use_32_bit_worker                       = false
      
      cors {
          allowed_origins     = [
              "https://ms.portal.azure.com",
              "https://portal.azure.com",
          ]
          support_credentials = false
      }

      dynamic "ip_restriction" {
        for_each = var.ip_deny
          content {
            action     = "Deny"
            headers    = []
            ip_address = ip_restriction.value
            priority   = 100
          }
        }
    }

    app_settings = {
        "APPLICATIONINSIGHTS_CONNECTION_STRING" = ""
        "AZURE_OPENAI_CHATGPT_DEPLOYMENT"       = local.chatgpt_name
        "AZURE_OPENAI_CHATGPT_MODEL"            = local.chatgpt_model
        "AZURE_OPENAI_EMB_DEPLOYMENT"           = local.emb_name
        "AZURE_OPENAI_EMB_MODEL_NAME"           = local.emb_model
        "AZURE_OPENAI_SERVICE"                  = local.cai_name
        "AZURE_SEARCH_INDEX"                    = var.search_index
        "AZURE_SEARCH_SERVICE"                  = local.cs_name
        "AZURE_STORAGE_ACCOUNT"                 = local.st_name
        "AZURE_STORAGE_CONTAINER"               = local.container_name
        "ENABLE_ORYX_BUILD"                     = "True"
        "OPENAI_API_KEY"                        = ""
        "OPENAI_HOST"                           = "azure"
        "OPENAI_ORGANIZATION"                   = ""
        "PYTHON_ENABLE_GUNICORN_MULTIWORKERS"   = "true"
        "SCM_DO_BUILD_DURING_DEPLOYMENT"        = "True"

    }

    identity {
      type = "SystemAssigned"
    }

    logs {
      detailed_error_messages = true
      failed_request_tracing  = true

      application_logs {
          file_system_level = "Verbose"
      }

      http_logs {
          file_system {
              retention_in_days = 1
              retention_in_mb   = 35
          }
      }
    }

    tags = merge(var.tags, {"azd-service-name" = "backend"})
}