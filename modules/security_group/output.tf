output "webserver_sg_id" {
  description = "ID of the web server security group"
  value       = aws_security_group.webserver_sg.id
}

output "private_sg_id" {
  description = "ID of the private instance security group"
  value       = aws_security_group.private_sg.id
}

output "lb_sg_id" {
  description = "ID of the load balancer security group"
  value       = aws_security_group.lb_sg.id
}


