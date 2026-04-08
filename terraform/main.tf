terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "aks-lab-rg"
  location = "eastus"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-lab-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "akslab"

  default_node_pool {
    name       = "system"
    node_count = 1
    vm_size    = "Standard_FX2ms_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  # ✅ REQUIRED for modern AKS
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
}
