output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "role_name" {
  value = aws_iam_role.ec2_role.name
}

output "policy_name" {
  value = aws_iam_policy.ec2_policy.name
}

output "policy_arn" {
  value = aws_iam_policy.ec2_policy.arn
}

output "role_arn" {
  value = aws_iam_role.ec2_role.arn
}

output "instance_profile_arn" {
  value = aws_iam_instance_profile.ec2_profile.arn
}
