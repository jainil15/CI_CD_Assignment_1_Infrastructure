output "public_instance_ip" {
  value = module.instance.public_instance_public_ipv4[0]
}
