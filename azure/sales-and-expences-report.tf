resource "azurerm_storage_account" "sales-and-expences-report" {
  name                     = "sales-and-expences-report-function"
  resource_group_name      = "${azurerm_resource_group.kiroku.name}"
  location                 = "${azurerm_resource_group.kiroku.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
