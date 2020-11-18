
# ----------------------------------------------------------------------------------------------
# IAM Role - StepFunction Execute Transcription State Machine
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "sf_exec_transcription_state_machine" {
  name               = "BootCamp_SF_ExecTranscriptionStateMachine"
  assume_role_policy = file("iam/principal/lambda.json")
}

resource "aws_iam_role_policy" "sf_exec_transcription_state_machine" {
  role   = aws_iam_role.sf_exec_transcription_state_machine.id
  policy = file("iam/lambda/exec_transcription_state_machine.json")
}

# ----------------------------------------------------------------------------------------------
# IAM Role - StepFunction Get Transcribe Job Status
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "sf_get_transcribe_job_status" {
  name               = "BootCamp_SF_GetTranscribeJobStatus"
  assume_role_policy = file("iam/principal/lambda.json")
}

resource "aws_iam_role_policy" "sf_get_transcribe_job_status" {
  role   = aws_iam_role.sf_get_transcribe_job_status.id
  policy = file("iam/lambda/get_transcribe_job_status.json")
}

# ----------------------------------------------------------------------------------------------
# IAM Role - StepFunction Interval Agent
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "sf_interval_agent" {
  name               = "BootCamp_SF_IntervalAgent"
  assume_role_policy = file("iam/principal/lambda.json")
}

resource "aws_iam_role_policy" "sf_interval_agent" {
  role   = aws_iam_role.sf_interval_agent.id
  policy = file("iam/lambda/interval_agent.json")
}

# ----------------------------------------------------------------------------------------------
# IAM Role - StepFunction Interval Queue
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "sf_interval_queue" {
  name               = "BootCamp_SF_IntervalQueue"
  assume_role_policy = file("iam/principal/lambda.json")
}

resource "aws_iam_role_policy" "sf_interval_queue" {
  role   = aws_iam_role.sf_interval_queue.id
  policy = file("iam/lambda/interval_queue.json")
}

# ----------------------------------------------------------------------------------------------
# IAM Role - StepFunction Process Transcription Result
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "sf_process_transcription_result" {
  name               = "BootCamp_SF_ProcessTranscriptionResult"
  assume_role_policy = file("iam/principal/lambda.json")
}

resource "aws_iam_role_policy" "sf_process_transcription_result" {
  role   = aws_iam_role.sf_process_transcription_result.id
  policy = file("iam/lambda/process_transcription_result.json")
}

# ----------------------------------------------------------------------------------------------
# IAM Role - StepFunction RealTime Queue Metrics Loop
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "sf_realtime_queue_metrics_loop" {
  name               = "BootCamp_SF_RealTimeQueueMetricsLoop"
  assume_role_policy = file("iam/principal/lambda.json")
}

resource "aws_iam_role_policy" "sf_realtime_queue_metrics_loop" {
  role   = aws_iam_role.sf_realtime_queue_metrics_loop.id
  policy = file("iam/lambda/realtime_queue_metrics_loop.json")
}

# ----------------------------------------------------------------------------------------------
# IAM Role - StepFunction RealTime Queue Metrics
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "sf_realtime_queue_metrics" {
  name               = "BootCamp_SF_RealTimeQueueMetrics"
  assume_role_policy = file("iam/principal/lambda.json")
}

resource "aws_iam_role_policy" "sf_realtime_queue_metrics" {
  role   = aws_iam_role.sf_realtime_queue_metrics.id
  policy = file("iam/lambda/realtime_queue_metrics.json")
}

# ----------------------------------------------------------------------------------------------
# IAM Role - StepFunction Submit Transcribe Job
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "sf_submit_transcribe_job" {
  name               = "BootCamp_SF_Submit_Transcribe_JOB"
  assume_role_policy = file("iam/principal/lambda.json")
}

resource "aws_iam_role_policy" "sf_submit_transcribe_job" {
  role   = aws_iam_role.sf_submit_transcribe_job.id
  policy = file("iam/lambda/submit_transcribe_job.json")
}

# ----------------------------------------------------------------------------------------------
# IAM Role - Salesforce CTR Trigger
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "sfdc_ctr_trigger" {
  name               = "BootCamp_SDFC_CTRTrigger"
  assume_role_policy = file("iam/principal/lambda.json")
}

resource "aws_iam_role_policy" "sfdc_ctr_trigger" {
  role   = aws_iam_role.sfdc_ctr_trigger.id
  policy = file("iam/lambda/sfdc_ctr_trigger.json")
}

# ----------------------------------------------------------------------------------------------
# IAM Role - StateMachine RealTime Queue Metrics Loop
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "sm_realtime_queue_metrics_loop" {
  name               = "BootCamp_RealTimeQueueMetricsLoop"
  assume_role_policy = file("iam/principal/step_function.json")
}

resource "aws_iam_role_policy" "sm_realtime_queue_metrics_loop" {
  role   = aws_iam_role.sm_realtime_queue_metrics_loop.id
  policy = file("iam/step_function/realtime_queue_metrics_loop.json")
}

# ----------------------------------------------------------------------------------------------
# IAM Role - StateMachine Transcribe
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "sm_transcribe" {
  name               = "BootCamp_Transcribe"
  assume_role_policy = file("iam/principal/step_function.json")
}

resource "aws_iam_role_policy" "sm_transcribe" {
  role   = aws_iam_role.sm_transcribe.id
  policy = file("iam/step_function/transcribe.json")
}

# ----------------------------------------------------------------------------------------------
# IAM Role - Salesforce Invoke API
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "sfdc_invoke_api" {
  name               = "BootCamp_SDFC_InvokeAPI"
  assume_role_policy = file("iam/principal/lambda.json")
}

resource "aws_iam_role_policy" "sfdc_invoke_api" {
  role   = aws_iam_role.sfdc_invoke_api.id
  policy = file("iam/lambda/sfdc_invoke_api.json")
}

# ----------------------------------------------------------------------------------------------
# IAM Role - StepFunction Generate Audio Recoding Streaming URL
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "sf_generate_audio_recoding_streaming_url" {
  name               = "BootCamp_SF_GenerateAudioRecodingStreamingURL"
  assume_role_policy = file("iam/principal/lambda.json")
}

resource "aws_iam_role_policy" "sf_generate_audio_recoding_streaming_url" {
  role   = aws_iam_role.sfdc_invoke_api.id
  policy = file("iam/lambda/sf_generate_audio_recoding_streaming_url.json")
}

# ----------------------------------------------------------------------------------------------
# IAM Role - Salesforce Contact Trace Record
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "sfdc_contact_trace_record" {
  name               = "BootCamp_SDFC_ContactTraceRecord"
  assume_role_policy = file("iam/principal/lambda.json")
}

resource "aws_iam_role_policy" "sfdc_contact_trace_record" {
  role   = aws_iam_role.sfdc_invoke_api.id
  policy = file("iam/lambda/sfdc_contact_trace_record.json")
}
