provider "azurerm"{
    features{}
  
}
resource "azurerm_resource_group" "example" {
  name="example-resources"
  location="East US"
}
resource "azurerm_virtual_network" "example" {
  name = "example-vnet"
  location = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "example" {
  name ="example-subnet"
  resource_group_name = azurerm_resource_group.example.name
  virtual_network_name=azurerm_virtual_network.example.name
  address_prefixes = ["10.0.1.0/24"]
  
}
resource "azurerm_network_security_group" "example" {
  name = "example-nsg"
  location = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

 security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Virtual Machine (VM)
resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd1234"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Network Interface
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

# Public IP
resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}

# Azure Kubernetes Service (AKS)
resource "azurerm_kubernetes_cluster" "example" {
  name                = "example-aks-cluster"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "exampleaks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Azure Blob Storage Backend Configuration
terraform {
  backend "azurerm" {
    resource_group_name   = "newresourcegrp"
    storage_account_name  = "newstorageaccountfor"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}


# output "resource_group_name"{
#     value=azurerm_resource_group.example.name
# }