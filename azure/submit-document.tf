resource "azurerm_storage_account" "submit-document" {
  name                     = "submit-document-function"
  resource_group_name      = "${azurerm_resource_group.kiroku.name}"
  location                 = "${azurerm_resource_group.kiroku.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "submit-document" {
  name                = "azure-functions-submit-document-service-plan"
  location            = "${azurerm_resource_group.kiroku.location}"
  resource_group_name = "${azurerm_resource_group.kiroku.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "submit-document" {
  name                      = "submit-document-function"
  location                  = "${azurerm_resource_group.kiroku.location}"
  resource_group_name       = "${azurerm_resource_group.kiroku.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.submit-document.id}"
  storage_connection_string = "${azurerm_storage_account.submit-document.primary_connection_string}"

  app_settings {
    "FUNCTIONS_WORKER_RUNTIME"  = "dotnet"
    "FUNCTION_APP_EDIT_MODE"    = "readonly"
    "HASH"                      = "${base64sha256(file("./dummy.zip"))}"
    "WEBSITE_RUN_FROM_PACKAGE"  = "https://${azurerm_storage_account.submit-document.name}.blob.core.windows.net/${azurerm_storage_container.submit-document.name}"
  }
}
