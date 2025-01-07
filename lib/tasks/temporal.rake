# lib/tasks/temporal.rake
require "temporal/worker"

namespace :temporal do
  desc "Start Temporal worker"
  task start_worker: :environment do
    worker = Temporal::Worker.new(binary_checksum: "2025-01-06_002")
    worker.register_workflow(ExampleWorkflow)
    worker.register_activity(ActivityA)
    worker.register_activity(ActivityB)
    worker.register_activity(ActivityC)
    worker.register_activity(ActivityD)
    worker.register_activity(ActivityE)

    worker.register_workflow(NotificationWorkflow)
    worker.register_activity(SendNotificationActivity)

    worker.register_workflow(CardWorkflow)
    worker.register_activity(CardActivity)

    worker.start
  end
end
