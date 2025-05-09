output "lb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.web_lb.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.web_tg.arn
}

output "lb_arn" {
  description = "ARN of the load balancer"
  value       = aws_lb.web_lb.arn
}

