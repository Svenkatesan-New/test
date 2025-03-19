provider "azurerm"{
    features{}
    
}
resource "azurerm_resource_group" "example" {
  name="github-actions-resource"
  location="East US"
}
output "resource_group_name"{
    value=azurerm_resource_group.example.name
}