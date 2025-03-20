provider "azurerm" {
  features {}
  subscription_id =  "5dfb4d57-e8e3-4bb5-8cec-d6857c3f385b"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-k8s-cluster"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-k8s-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-k8s-cluster"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-cluster"

  default_node_pool {
    name       = "default"
    node_count = 3 
    vm_size    = "Standard_DS2_V2"  

    
  }
 

  identity {
    type = "SystemAssigned"
  }
  
  tags = {
    Environment = "Production"
  }
}


# output "kubeconfig" {
#   value = azurerm_kubernetes_cluster.aks.kube_config[0]
#   sensitive = true
# }
terraform {
  backend "azurerm" {
    resource_group_name   = "newresourcegrp"
    storage_account_name  = "newstorageaccountfor"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}

