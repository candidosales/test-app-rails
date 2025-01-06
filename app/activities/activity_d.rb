class ActivityD < Temporal::Activity
  def execute(name)
    sleep 15
    "#{name} -> Activity D"
    Temporal.start_workflow(
      NotificationWorkflow,
      input: "#{name} -> Activity D")
  end
end
