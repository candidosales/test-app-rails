# lib/tasks/temporal.rake
require "temporal/worker"

namespace :temporal do
  desc "Start Temporal worker"
  task start_worker: :environment do
    worker = Temporal::Worker.new(binary_checksum: "2025-01-06_002")
    # worker = Temporal::Worker.new
    worker.register_workflow(ExampleWorkflow)
    worker.register_activity(ActivityA)
    worker.register_activity(ActivityB)
    worker.register_activity(ActivityC)
    # worker.register_activity(ActivityD)
    # worker.register_activity(ActivityE)
    # worker.register_activity(ActivityF)
    # worker.register_activity(ActivityH)
    # worker.register_activity(ActivityJ)
    # worker.register_activity(ActivityI)
    # worker.register_activity(ActivityL)

    worker.register_workflow(CardBWorkflow)
    worker.register_activity(CardBActivity)

    # worker.register_workflow(NotificationBWorkflow)
    # worker.register_activity(SendNotificationActivity)

    worker.start
  end
end
