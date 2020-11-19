# ----------------------------------------------------------------------------------------------
# Dynamodb Table - Call History
# ----------------------------------------------------------------------------------------------
resource "aws_dynamodb_table" "call_history" {
  name           = "CallHistory"
  billing_mode   = "PROVISIONED"
  write_capacity = 2
  read_capacity  = 2
  hash_key       = "Timestamp"
  range_key      = "CallerId"

  attribute {
    name = "Timestamp"
    type = "S"
  }

  attribute {
    name = "CallerId"
    type = "S"
  }

  global_secondary_index {
    name            = "gsiIdx1"
    hash_key        = "CallerId"
    range_key       = "Timestamp"
    write_capacity  = 2
    read_capacity   = 2
    projection_type = "INCLUDE"
  }
}

# ----------------------------------------------------------------------------------------------
# Secret Manager - Salesforce
# ----------------------------------------------------------------------------------------------
resource "aws_secretsmanager_secret" "salesforce" {
  name = "bootcamp-salesforce-credentials"
}

# ----------------------------------------------------------------------------------------------
# Secret Manager Version - Salesforce
# ----------------------------------------------------------------------------------------------
resource "aws_secretsmanager_secret_version" "salesforce" {
  secret_id     = aws_secretsmanager_secret.salesforce.id
  secret_string = jsonencode(local.sdfc_credentials)
}

# ----------------------------------------------------------------------------------------------
# Kinesis Stream
# ----------------------------------------------------------------------------------------------
resource "aws_kinesis_stream" "stream" {
  name             = "bootcamp-kinesis-stream"
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}

# ----------------------------------------------------------------------------------------------
# State Machine - RealTime Metrics Loop Job
# ----------------------------------------------------------------------------------------------
resource "aws_sfn_state_machine" "realtime_queue_metrics_loop" {
  name       = "BootCamp_RealTimeQueueMetricsLoopJob"
  role_arn   = aws_iam_role.sm_realtime_queue_metrics_loop.arn
  definition = file("sm/realtime_metrics_loop.json")
}

# ----------------------------------------------------------------------------------------------
# State Machine - Transcribe
# ----------------------------------------------------------------------------------------------
resource "aws_sfn_state_machine" "transcribe" {
  name       = "BootCamp_Transcribe"
  role_arn   = aws_iam_role.sm_transcribe.arn
  definition = file("sm/transcribe.json")
}

# resource "aws_cloudwatch_event_rule" "EventsRule" {
#   name                = "serverlessrepo-AmazonConn-sfRealTimeQueueMetricsCr-1DETLF9EXY3YW"
#   description         = "Executes Step Functions every minute"
#   schedule_expression = "rate(1 minute)"
# }

# resource "aws_cloudwatch_event_target" "CloudWatchEventTarget" {
#   rule = "serverlessrepo-AmazonConn-sfRealTimeQueueMetricsCr-1DETLF9EXY3YW"
#   arn  = "arn:aws:events:ap-northeast-1:925866981400:rule/serverlessrepo-AmazonConn-sfRealTimeQueueMetricsCr-1DETLF9EXY3YW"
# }
