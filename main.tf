provider "azurerm"{
    features{}
    
}
resource "azurerm_resource_group" "example" {
  name="example-resources"
  location="East US"
}
output "resource_group_name"{
    value=azurerm_resource_group.example.name
}