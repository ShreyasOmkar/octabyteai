output "app_url" {
  description = "Public application URL. HTTPS is intentionally deferred until a domain and certificate exist."
  value       = "http://${aws_lb.app.dns_name}"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.app.name
}

output "db_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "db_secret_arn" {
  description = "RDS-managed Secrets Manager secret ARN; the secret value is never stored in Terraform configuration."
  value       = aws_db_instance.main.master_user_secret[0].secret_arn
}

output "application_dashboard" {
  value = aws_cloudwatch_dashboard.application.dashboard_name
}

output "database_dashboard" {
  value = aws_cloudwatch_dashboard.database.dashboard_name
}
