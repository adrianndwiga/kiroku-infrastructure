resource "azurerm_storage_account" "sales-and-expences-report" {
  name                     = "sales-and-expences-report-function"
  resource_group_name      = "${azurerm_resource_group.kiroku.name}"
  location                 = "${azurerm_resource_group.kiroku.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "sales-and-expences-report" {
  name                = "azure-functions-sales-and-expences-report-service-plan"
  location            = "${azurerm_resource_group.kiroku.location}"
  resource_group_name = "${azurerm_resource_group.kiroku.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "sales-and-expences-report" {
  name                      = "sales-and-expences-report-function"
  location                  = "${azurerm_resource_group.kiroku.location}"
  resource_group_name       = "${azurerm_resource_group.kiroku.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.sales-and-expences-report.id}"
  storage_connection_string = "${azurerm_storage_account.sales-and-expences-report.primary_connection_string}"
}
