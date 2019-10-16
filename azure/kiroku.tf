resource "azurerm_storage_blob" "kiroku" {
  name                   = "dummy.zip"
  resource_group_name    = "${azurerm_resource_group.kiroku.name}"
  storage_account_name   = "${azurerm_storage_account.kiroku.name}"
  storage_container_name = "${azurerm_storage_container.kiroku.name}"
  type                   = "blob"
  source                 = "dummy.zip"
}