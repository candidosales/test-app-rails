class ActivityD < Temporal::Activity
  def execute(name)
    sleep 15
    "#{name} -> Activity D"
    Temporal.start_workflow(
      NotificationBWorkflow,
      input: "#{name} -> Activity D")
  end
end
