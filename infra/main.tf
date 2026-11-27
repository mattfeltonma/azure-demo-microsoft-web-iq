########## Create base resources
##########
##########

## Use time_static to generate a timestamp which will be used in created_date tag. Use this instead of timestamp
## so Terraform doesn't freak out every time apply is run again
##
resource "time_static" "created" {}

## Create a random string
##
resource "random_string" "unique" {
  length  = 3
  numeric = true
  lower   = true
  upper   = false
  special = false
}

########## Create a resource group for the workload resources
##########
##########

## Create resource group where resources in this template will be deployed to
##
resource "azurerm_resource_group" "rg_webiq" {
  name     = "rgwebiq${local.region_abbreviations[var.region]}${random_string.unique.result}"
  location = var.region
  tags     = local.tags

  lifecycle {
    ignore_changes = [
      tags["created_by"]
    ]
  }
}

########## Create a Microsoft Web IQ Account
##########
##########

## Create Microsoft Web IQ Account
##
resource "azapi_resource" "web_iq_account" {
  depends_on = [
    azurerm_resource_group.rg_webiq
  ]

  type                      = "Microsoft.WebIQ/accounts@2026-06-01-preview"
  name                      = "webiq${local.region_abbreviations[var.region]}${random_string.unique.result}"
  parent_id                 = azurerm_resource_group.rg_webiq.id
  location                  = "Global"
  schema_validation_enabled = false

  body = {
    kind = "WebIQ.Grounding"
    sku = {
      "name" = "G3"
    }
    properties = {
        # TODO: 11/24/2026 Unsure of what this does
        statisticsEnabled = false
    }
    tags = local.tags
  }

  lifecycle {
    ignore_changes = [
      tags["created_by"]
    ]
  }
}

