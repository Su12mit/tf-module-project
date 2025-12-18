output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.web_asg.name
}

output "ec2_sg_id" {
  description = "Security group ID of EC2 instances"
  value       = aws_security_group.ec2_sg.id
}

output "alb_arn_suffix" {
  value = aws_lb.web_alb.arn_suffix
}

output "target_group_arn_suffix" {
  value = aws_lb_target_group.web_tg.arn_suffix
}
