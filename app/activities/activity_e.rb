class ActivityE < Temporal::Activity
  def execute(name)
    sleep 15
    "#{name} -> Activity E"
    Temporal.start_workflow(
      CardWorkflow,
      input: "#{name} -> Activity E")
  end
end
