resource "azurerm_storage_account" "tag-document" {
  name                     = "tag-document-storage-account"
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

resource "azurerm_function_app" "tag-document" {
  name                      = "tag-document-function"
  location                  = "${azurerm_resource_group.kiroku.location}"
  resource_group_name       = "${azurerm_resource_group.kiroku.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.tag-document.id}"
  storage_connection_string = "${azurerm_storage_account.tag-document.primary_connection_string}"

  app_settings {
    "FUNCTIONS_WORKER_RUNTIME"  = "dotnet"
    "FUNCTION_APP_EDIT_MODE"    = "readonly"
    "HASH"                      = "${base64sha256(file("./dummy.zip"))}"
    "WEBSITE_RUN_FROM_PACKAGE"  = "https://${azurerm_storage_account.tag-document.name}.blob.core.windows.net/${azurerm_storage_container.submit-statement.name}"
  }
}

resource "azure_storage_queue" "tag-document-storage-queue" {
  name                 = "tag-document-storage-queue"
  resource_group_name  = "${azurerm_resource_group.kiroku.name}"
  storage_account_name = "${azurerm_storage_account.tag-document.name}"
}

resource "azurerm_storage_container" "tag-document" {
  name                  = "tag-document"
  resource_group_name   = "${azurerm_resource_group.kiroku.name}"
  storage_account_name  = "${azurerm_storage_account.tag-document.name}"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "tag-document" {
  name                   = "dummy.zip"
  resource_group_name    = "${azurerm_resource_group.kiroku.name}"
  storage_account_name   = "${azurerm_storage_account.tag-document.name}"
  storage_container_name = "${azurerm_storage_container.tag-document.name}"
  type                   = "blob"
  source                 = "dummy.zip"
}
