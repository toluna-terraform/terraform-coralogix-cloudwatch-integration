variable "app_name" {
  description = "application name"
  type        = string
}

variable "loggroup_envs" {
  description = "list of environment log groups"
  type = list
}

variable "region" {
  description = "log groups region"
  default = "us-east-1"
}