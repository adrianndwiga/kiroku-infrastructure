resource "azurerm_storage_account" "transactions-update" {
  name                     = "transactions-update-function"
  resource_group_name      = "${azurerm_resource_group.kiroku.name}"
  location                 = "${azurerm_resource_group.kiroku.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "transactions-update" {
  name                = "azure-functions-transactions-update-service-plan"
  location            = "${azurerm_resource_group.kiroku.location}"
  resource_group_name = "${azurerm_resource_group.kiroku.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "transactions-update" {
  name                      = "transactions-update-function"
  location                  = "${azurerm_resource_group.kiroku.location}"
  resource_group_name       = "${azurerm_resource_group.kiroku.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.transactions-update.id}"
  storage_connection_string = "${azurerm_storage_account.transactions-update.primary_connection_string}"

  app_settings {
    "FUNCTIONS_WORKER_RUNTIME"  = "dotnet"
    "FUNCTION_APP_EDIT_MODE"    = "readonly"
    "HASH"                      = "${base64sha256(file("./dummy.zip"))}"
    "WEBSITE_RUN_FROM_PACKAGE"  = "https://${azurerm_storage_account.transactions-update.name}.blob.core.windows.net/${azurerm_storage_container.sales-azurerm_storage_account.transactions-update.name}"
  }
}

resource "azurerm_storage_container" "transactions-update" {
  name                  = "transactions-update"
  resource_group_name   = "${azurerm_resource_group.kiroku.name}"
  storage_account_name  = "${azurerm_storage_account.transactions-update.name}"
  container_access_type = "private"
}
