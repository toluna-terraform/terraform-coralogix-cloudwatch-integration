module "coralogix" {
  source                      = "../../"
  version                     = "~>0.0.1"
  app_name                    = "my_app"
  loggroup_envs               = ['qa','dev','prod']
  region                      = "us-east-1"
}