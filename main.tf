terraform {
  required_providers {
      azurerm = {
          source = "hashicorp/azurerm"
          version = "=2.48.0"
      }
  }

  backend "remote" {
    hostname = "app.terraform.io"
    organization = "WillTest"

    workspaces {
      name = "LocalWorkspaceTest"
    }
  }
}

provider "azurerm" {
    alias = "azurerm"
  features {}
}

locals {
  name = "MyResourceGroup"
  location = "eastus"
}

module "resourcegroup" {
  source = "github.com/wiwilson/terraform-azurerg-example"
  providers = {
    azurerm = azurerm.azurerm
  }

  name = local.name
  location = local.location
}

module "appservice" {
  count = var.createAppService ? 1 : 0
  source = "github.com/wiwilson/terraform-azureappservice-example"
  providers = {
    azurerm = azurerm.azurerm
  }
  name = local.name
  location = local.location
  tag = module.resourcegroup.resourcegroupid
}