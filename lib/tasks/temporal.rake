# lib/tasks/temporal.rake
require "temporal/worker"

namespace :temporal do
  desc "Start Temporal worker"
  task start_worker: :environment do
    worker = Temporal::Worker.new
    worker.register_workflow(ExampleWorkflow)
    worker.register_activity(ActivityA)
    worker.register_activity(ActivityB)
    worker.start
  end
end
