output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "db_name" {
  value = aws_db_instance.postgres.db_name
}

output "secret_arn" {
  value = aws_secretsmanager_secret.db_secret.arn
}

output "secret_name" {
  value = aws_secretsmanager_secret.db_secret.name
}