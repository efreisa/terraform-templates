locals {
  cai_name = "cog-${var.name}"
  chatgpt_name = "chat"
  chatgpt_model = "gpt-35-turbo"
  emb_name = "embedding"
  emb_model = "text-embedding-ada-002"
}

resource "azurerm_cognitive_account" "cognitive_account" {
    name = local.cai_name
    location = var.location
    resource_group_name = var.resource_group_name
    kind = "OpenAI"

    sku_name = "S0"

    custom_subdomain_name       = local.cai_name
    dynamic_throttling_enabled  = false
    fqdns                       = []

    tags = var.tags
}

resource "azurerm_cognitive_deployment" "dep_chat" {
  cognitive_account_id = azurerm_cognitive_account.cognitive_account.id
  name                 = local.chatgpt_name

  model {
    format  = "OpenAI"
    name    = local.chatgpt_model
    version = "0613"
  }
  scale {
    type = "Standard"
    capacity = 30
  }
}

resource "azurerm_cognitive_deployment" "dep_emb" {
  cognitive_account_id = azurerm_cognitive_account.cognitive_account.id
  name                 = local.emb_name

  model {
    format  = "OpenAI"
    name    = local.emb_model
    version = 2
  }
  scale {
    type = "Standard"
    capacity = 20
  }
}