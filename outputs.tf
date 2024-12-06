#-----outputs.tf-----
#====================
output "Webserver-Public-URL" {
  value = "http://${module.compute.server_ip}"
}