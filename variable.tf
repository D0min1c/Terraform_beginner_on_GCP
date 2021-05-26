# provider
variable "credentials" {
  default = "terraform-test-2021-21be80bc9de7.json" # import service key
}
variable "project" {
  type = object({
    id     = string
    name   = string
    number = string
  })
  default = {
    id     = "terraform-example" # import project ID
    name   = "terraform-example" # import project name
    number = "XXXXXXXXXXXX" # import project number 12
    kname  = "테라폼프로젝트" # import K-project name
    team   = "cloud-infra-team" # import team
    admin  = "dominic" # import admin
    dir = "INFRA" # import project folder GAME, PLATFORM, RND
    env    = "TEST" # change 구분 DEV, STG, TEST, LIVE
  }
}

# vpc
variable "network_name" {
  default = "vpc-terraform-test" # change
}
variable "subnet_seoul" {
  default = {
    name   = "seoul"
    region = "asia-northeast3"
    cidr   = "172.20.0.0/24" # Don't use 172.17.0.0/16 Google local service reserved ip
  }
}

# template
/***
variable "ssh" {
  type = object({
    key  = string
    user = string
  })
  default = {
    key  = "google-cloudsystem.pem.pub" # change, make ssh-key
    user = "cloudsystem" # change
  }
}
***/