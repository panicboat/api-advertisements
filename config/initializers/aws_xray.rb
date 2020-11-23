Rails.application.config.xray = {
  name: ENV['MY_SERVICE_NAME'],
  patch: %I[net_http aws_sdk],
  active_record: true,
  context_missing: 'LOG_ERROR'
}
