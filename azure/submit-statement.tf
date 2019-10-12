resource "azurerm_storage_account" "submit-statement" {
  name                     = "submit-statement-function"
  resource_group_name      = "${azurerm_resource_group.kiroku.name}"
  location                 = "${azurerm_resource_group.kiroku.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "submit-statement" {
  name                = "azure-functions-submit-statement-service-plan"
  location            = "${azurerm_resource_group.kiroku.location}"
  resource_group_name = "${azurerm_resource_group.kiroku.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "submit-statement" {
  name                      = "submit-statement-function"
  location                  = "${azurerm_resource_group.kiroku.location}"
  resource_group_name       = "${azurerm_resource_group.kiroku.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.submit-statement.id}"
  storage_connection_string = "${azurerm_storage_account.submit-statement.primary_connection_string}"

  app_settings {
    "FUNCTIONS_WORKER_RUNTIME"  = "dotnet"
    "FUNCTION_APP_EDIT_MODE"    = "readonly"
    "HASH"                      = "${base64sha256(file("./dummy.zip"))}"
  }
}

resource "azure_storage_queue" "submit-statement-storage-queue" {
  name                 = "submit-statement-storage-queue"
  resource_group_name  = "${azurerm_resource_group.kiroku.name}"
  storage_account_name = "${azurerm_storage_account.submit-statement.name}"
}

resource "azurerm_storage_container" "submit-statement" {
  name                  = "submit-statement"
  resource_group_name   = "${azurerm_resource_group.kiroku.name}"
  storage_account_name  = "${azurerm_storage_account.submit-statement.name}"
  container_access_type = "private"
}

