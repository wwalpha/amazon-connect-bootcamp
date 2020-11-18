# ----------------------------------------------------------------------------------------------
# Kinesis Stream Arn
# ----------------------------------------------------------------------------------------------
output "kinesis_stream_arn" {
  value = aws_kinesis_stream.stream.arn
}

# ----------------------------------------------------------------------------------------------
# Secret Manager Arn
# ----------------------------------------------------------------------------------------------
output "secret_manager_arn" {
  value = aws_secretsmanager_secret.salesforce.arn
}