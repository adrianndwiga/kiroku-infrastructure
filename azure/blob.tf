resource "azurerm_storage_account" "kiroku" {
  name                     = "kiroku"
  resource_group_name      = "${azurerm_resource_group.kiroku.name}"
  location                 = "${azurerm_resource_group.kiroku.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "kiroku" {
  name                  = "content"
  resource_group_name   = "${azurerm_resource_group.kiroku.name}"
  storage_account_name  = "${azurerm_storage_account.kiroku.name}"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "kiroku" {
  name                   = "dummy.zip"
  resource_group_name    = "${azurerm_resource_group.kiroku.name}"
  storage_account_name   = "${azurerm_storage_account.kiroku.name}"
  storage_container_name = "${azurerm_storage_container.kiroku.name}"
  type                   = "blob"
  source                 = "dummy.zip"
}
