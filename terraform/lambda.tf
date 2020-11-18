# ----------------------------------------------------------------------------------------------
# Lambda Function - Salesforce Invoke API
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "sfdc_invoke_api" {
  filename      = "index.zip"
  function_name = "bootcamp-sfdc-invoke-api"
  handler       = "index.handler"
  memory_size   = 256
  role          = aws_iam_role.sfdc_invoke_api.arn
  runtime       = "nodejs12.x"
  timeout       = 6
  environment {
    variables = {
      SF_HOST                            = var.sf_host
      SF_CREDENTIALS_SECRETS_MANAGER_ARN = "arn:aws:secretsmanager:ap-northeast-1:925866981400:secret:prod/bootcamp-DzYOOq"
      SF_PRODUCTION                      = "false"
      SF_VERSION                         = var.sf_version
      SF_ADAPTER_NAMESPACE               = "amazonconnect"
      SF_USERNAME                        = "wwalpha@gmail.com"
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Lambda Function - Salesforce CTR Trigger
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "sfdc_ctr_trigger" {
  filename      = "index.zip"
  function_name = "bootcamp-sfdc-ctr-trigger"
  handler       = "index.handler"
  memory_size   = 256
  role          = aws_iam_role.sfdc_ctr_trigger.arn
  runtime       = "nodejs12.x"
  timeout       = 20
  environment {
    variables = {
      EXECUTE_TRANSCRIPTION_STATE_MACHINE_LAMBDA = "serverlessrepo-AmazonConn-sfExecuteTranscriptionSt-6I3PEV335TD4"
      EXECUTE_CTR_IMPORT_LAMBDA                  = aws_lambda_function.sfdc_contact_trace_record.arn
      POSTCALL_RECORDING_IMPORT_ENABLED          = "true"
      POSTCALL_CTR_IMPORT_ENABLED                = "true"
      POSTCALL_TRANSCRIBE_ENABLED                = "true"
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Lambda Function - Salesforce Contact Trace Record
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "sfdc_contact_trace_record" {
  filename      = "index.zip"
  function_name = "bootcamp-sfdc-contact-trace-record"
  handler       = "index.handler"
  memory_size   = 256
  role          = aws_iam_role.sfdc_contact_trace_record.arn
  runtime       = "nodejs12.x"
  timeout       = 30
  environment {
    variables = {
      SF_HOST                            = var.sf_host
      SF_CREDENTIALS_SECRETS_MANAGER_ARN = "arn:aws:secretsmanager:ap-northeast-1:925866981400:secret:prod/bootcamp-DzYOOq"
      SF_PRODUCTION                      = "false"
      SF_VERSION                         = var.sf_version
      SF_ADAPTER_NAMESPACE               = "amazonconnect"
      SF_USERNAME                        = "wwalpha@gmail.com"
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Lambda Function - StepFunction RealTime Queue Metrics Loop Job
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "sf_realtime_queue_metrics_loop" {
  filename      = "index.zip"
  function_name = "bootcamp-sf-realtime-queue-metrics-loop"
  handler       = "index.handler"
  memory_size   = 256
  role          = aws_iam_role.sf_realtime_queue_metrics_loop.arn
  runtime       = "nodejs12.x"
  timeout       = 10
  environment {
    variables = {
      SFDC_REALTIME_QUEUE_METRICS_LAMBDA = aws_lambda_function.sf_realtime_queue_metrics.arn
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Lambda Function - StepFunction RealTime Queue Metrics
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "sf_realtime_queue_metrics" {
  filename      = "index.zip"
  function_name = "bootcamp-sf-realtime-queue-metrics"
  handler       = "index.handler"
  memory_size   = 256
  role          = aws_iam_role.sf_realtime_queue_metrics.arn
  runtime       = "nodejs12.x"
  timeout       = 900
  environment {
    variables = {
      SF_HOST                                = var.sf_host
      SF_CREDENTIALS_SECRETS_MANAGER_ARN     = "arn:aws:secretsmanager:ap-northeast-1:925866981400:secret:prod/bootcamp-DzYOOq"
      SF_PRODUCTION                          = "false"
      SF_VERSION                             = var.sf_version
      SF_ADAPTER_NAMESPACE                   = "amazonconnect"
      SF_USERNAME                            = "wwalpha@gmail.com"
      AMAZON_CONNECT_INSTANCE_ID             = var.connect_instance_id
      AMAZON_CONNECT_QUEUE_MAX_RESULT        = "100"
      AMAZON_CONNECT_QUEUEMETRICS_MAX_RESULT = "100"
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Lambda Function - StepFunction Interval Queue
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "sf_interval_queue" {
  filename      = "index.zip"
  function_name = "bootcamp-sf-interval-queue"
  handler       = "index.handle"
  memory_size   = 256
  role          = aws_iam_role.sf_interval_queue.arn
  runtime       = "nodejs12.x"
  timeout       = 60
  environment {
    variables = {
      SF_HOST                            = var.sf_host
      SF_CREDENTIALS_SECRETS_MANAGER_ARN = "arn:aws:secretsmanager:ap-northeast-1:925866981400:secret:prod/bootcamp-DzYOOq"
      SF_PRODUCTION                      = "false"
      SF_VERSION                         = var.sf_version
      SF_ADAPTER_NAMESPACE               = "amazonconnect"
      SF_USERNAME                        = "wwalpha@gmail.com"
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Lambda Function - StepFunction Interval Agent
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "sf_interval_agent" {
  filename      = "index.zip"
  function_name = "bootcamp-sf-interval-agent"
  handler       = "index.handler"
  memory_size   = 256
  role          = aws_iam_role.sf_interval_agent.arn
  runtime       = "nodejs12.x"
  timeout       = 60
  environment {
    variables = {
      SF_HOST                            = var.sf_host
      SF_CREDENTIALS_SECRETS_MANAGER_ARN = "arn:aws:secretsmanager:ap-northeast-1:925866981400:secret:prod/bootcamp-DzYOOq"
      SF_PRODUCTION                      = "false"
      SF_VERSION                         = var.sf_version
      SF_ADAPTER_NAMESPACE               = "amazonconnect"
      SF_USERNAME                        = "wwalpha@gmail.com"
    }
  }
}


# ----------------------------------------------------------------------------------------------
# Lambda Function - StepFunction Submit Transcribe Job
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "sf_submit_transcribe_job" {
  filename      = "index.zip"
  function_name = "bootcamp-sf-submit-transcribe-job"
  handler       = "index.handler"
  memory_size   = 256
  role          = aws_iam_role.sf_submit_transcribe_job.arn
  runtime       = "nodejs12.x"
  timeout       = 10
}

# ----------------------------------------------------------------------------------------------
# Lambda Function - StepFunction Process Transcription Result
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "sf_process_transcription_result" {
  filename      = "index.zip"
  function_name = "bootcamp-sf-process-transcription-result"
  handler       = "index.handler"
  memory_size   = 256
  role          = aws_iam_role.sf_process_transcription_result.arn
  runtime       = "nodejs12.x"
  timeout       = 60
  environment {
    variables = {
      SF_ADAPTER_NAMESPACE   = "amazonconnect"
      SFDC_INVOKE_API_LAMBDA = aws_lambda_function.sfdc_invoke_api.arn
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Lambda Function - StepFunction Get Transcribe Job Status
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "sf_get_transcribe_job_status" {
  filename      = "index.zip"
  function_name = "bootcamp-sf-transcribe-job-status"
  handler       = "index.handler"
  memory_size   = 256
  role          = aws_iam_role.sf_get_transcribe_job_status.arn
  runtime       = "nodejs12.x"
  timeout       = 10
}

# ----------------------------------------------------------------------------------------------
# Lambda Function - StepFunction Execute Transcription State Machine
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "sf_exec_transcription_state_machine" {
  filename      = "index.zip"
  function_name = "bootcamp-sf-exec-transcription-statemachine"
  handler       = "index.handler"
  memory_size   = 256
  role          = aws_iam_role.sf_exec_transcription_state_machine.arn
  runtime       = "nodejs12.x"
  timeout       = 120
  environment {
    variables = {
      TRANSCRIPTS_DESTINATION_KMS  = ""
      MEDIA_FORMAT                 = "wav"
      TRANSCRIBE_STATE_MACHINE_ARN = "arn:aws:states:ap-northeast-1:925866981400:stateMachine:sfTranscribeStateMachine-kUjUOn9gmBXl"
      WAIT_TIME                    = "20"
      SF_ADAPTER_NAMESPACE         = "amazonconnect"
      TRANSCRIPTS_DESTINATION      = "connect-dd6118f52dbf"
      SFDC_INVOKE_API_LAMBDA       = aws_lambda_function.sfdc_invoke_api.arn
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Lambda Function - StepFunction Generate Audio Recoding Streaming URL
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "sf_generate_audio_recoding_streaming_url" {
  filename      = "index.zip"
  function_name = "bootcamp-sf-generate-audio-recoding-stream-url"
  handler       = "index.handler"
  memory_size   = 256
  role          = aws_iam_role.sf_generate_audio_recoding_streaming_url.arn
  runtime       = "nodejs12.x"
  timeout       = 10
  environment {
    variables = {
      SF_HOST                             = var.sf_host
      SF_CREDENTIALS_SECRETS_MANAGER_ARN  = "arn:aws:secretsmanager:ap-northeast-1:925866981400:secret:prod/bootcamp-DzYOOq"
      CLOUDFRONT_DISTRIBUTION_DOMAIN_NAME = "d1j9073lrth7y0.cloudfront.net"
    }
  }
}
