#-----compute/variables.tf-----
#===============================
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "subnet_ips" {}

variable "security_group" {}

variable "subnets" {}
# variable defined for exchangin keys between local and EC2
variable "ssh_key_public" {
  type = string
  # path to the local where keys are stored
  default = "C:\\Users\\prave\\.ssh\\id_rsa.pub"
}  
# variable defined for Private key
variable "ssh_key_private"{
  type = string
  # path to the local where keys are stored
  default = "C:\\Users\\prave\\.ssh\\id_rsa"
}