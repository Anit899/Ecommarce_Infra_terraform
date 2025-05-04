module "resource_group" {
  source                  = "../../module/azurerm_resource_group"
  resource_group_name     = var.rg_names
  resource_group_location = var.rg_location
}


module "storage_account" {
  depends_on              = [module.resource_group]
  source                  = "../../module/aurerm_storage_account"
  storage_account_name    = var.stg_names
  resource_group_name     = var.rg_names
  resource_group_location = var.rg_location
}
