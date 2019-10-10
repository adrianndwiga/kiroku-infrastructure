resource "azurerm_resource_group" "submit-statement" {
  name     = "azure-functions-submit-statement-rg"
  location = "westus2"
}

resource "azurerm_storage_account" "submit-statement" {
  name                     = "submit-statement-function"
  resource_group_name      = "${azurerm_resource_group.submit-statement.name}"
  location                 = "${azurerm_resource_group.submit-statement.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "submit-statement" {
  name                = "azure-functions-submit-statement-service-plan"
  location            = "${azurerm_resource_group.submit-statement.location}"
  resource_group_name = "${azurerm_resource_group.submit-statement.name}"
  kind                = "SubmitStatement"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "submit-statement" {
  name                      = "submit-statement-functions"
  location                  = "${azurerm_resource_group.submit-statement.location}"
  resource_group_name       = "${azurerm_resource_group.submit-statement.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.submit-statement.id}"
  storage_connection_string = "${azurerm_storage_account.submit-statement.primary_connection_string}"
}