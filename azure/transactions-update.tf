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
}


resource "azure_storage_queue" "transactions-update-storage-queue" {
  name                 = "transactions-update-storage-queue"
  resource_group_name  = "${azurerm_resource_group.kiroku.name}"
  storage_account_name = "${azurerm_storage_account.transactions-update.name}"
}
