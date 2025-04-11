output "bastion_id" {
  description = "ID of the bastion server"
  value       = aws_instance.bastion.id
}

output "bastion_public_ip" {
  description = "Public IP of the bastion server"
  value       = aws_instance.bastion.public_ip
}

output "webserver4_id" {
  description = "ID of WebServer4"
  value       = aws_instance.webserver4.id
}

output "webserver5_id" {
  description = "ID of WebServer5"
  value       = aws_instance.webserver5.id
}

output "vm6_id" {
  description = "ID of VM6"
  value       = aws_instance.vm6.id
}