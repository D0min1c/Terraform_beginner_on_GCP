# provider
variable "credentials" {
  default = "XXXXXXXXXX.json" # change
}
variable "project" {
  type = object({
    id     = string
    name   = string
    number = string
  })
  default = {
    name   = "XXXXXXXXXX" # change
    id     = "XXXXXXXXXX" # change
    number = "XXXXXXXXXX" # change
    kname  = "인프라서비스팀" # change 
    team   = "infra_service_team" # change 
    admin  = "dominic" # change 
|    env    = "DEV" # change 구분 DEV, STG,LIVE
  }
}
# vpc
variable "network_name" {
  default = "vpc-XXXXXXX" # change
}
variable "subnet_XXXXXXX" {
  default = {
    name   = "seoul"
    region = "asia-northeast3"
    cidr   = "172.20.10.0/24" # Don't use 172.17.0.0/16 Google local service reserved ip
  }
}

# template
variable "ssh" {
  type = object({
    key  = string
    user = string
  })
  default = {
    key  = "XXXXXXX.pem.pub" # change, make ssh-key
    user = "XXXXXXX" # change
  }
}
