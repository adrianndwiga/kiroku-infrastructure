resource "azurerm_storage_account" "tag-document" {
  name                     = "tag-document-function"
  resource_group_name      = "${azurerm_resource_group.kiroku.name}"
  location                 = "${azurerm_resource_group.kiroku.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "tag-document" {
  name                = "azure-functions-tag-document-service-plan"
  location            = "${azurerm_resource_group.kiroku.location}"
  resource_group_name = "${azurerm_resource_group.kiroku.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}