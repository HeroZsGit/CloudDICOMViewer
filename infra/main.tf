provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "clouddicomviewer-rg"
  location = "Central Europe"
}

resource "azurerm_static_site" "angular_app" {
  name                = "CloudDICOMViewer-angular"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_container_instance" "cpp_backend" {
  name                  = "CloudDICOMViewer-backend"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  os_type               = "Linux"

  container {
    name   = "dicomprocessor"
    image  = "yourdockerimage/dicom-backend"
    cpu    = "0.5"
    memory = "1.5"
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = "clouddicomviewerstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "dicom_container" {
  name                  = "dicomfiles"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
