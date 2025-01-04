class ExampleWorkflow < Temporal::Workflow
  def execute(name)
    result = ActivityA.execute!(name)
    result = ActivityB.execute!(result)
    result = SendNotificationActivity.execute!(result)
    logger.info "Hello, #{result}!"
  end
end
