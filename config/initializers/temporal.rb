require "temporal-ruby"
require "grpc"

Temporal.configure do |config|
  config.host = "localhost"
  config.port = 7233
  config.namespace = "ruby-samples"
  config.task_queue = "hello-world"
  config.credentials = :this_channel_is_insecure
end

begin
  Temporal.register_namespace("ruby-samples", "A safe space for playing with Temporal Ruby")
rescue Temporal::NamespaceAlreadyExistsFailure
  nil # service was already registered
rescue GRPC::Unavailable, Errno::ECONNREFUSED => e
  Rails.logger.warn "Temporal server is not available: #{e.message}" if defined?(Rails.logger)
  # Continue without Temporal for development
end
