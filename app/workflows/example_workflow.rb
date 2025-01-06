class ExampleWorkflow < Temporal::Workflow
  def execute(name)
    result = ActivityA.execute!(name)
    result = ActivityB.execute!(result)
    result = SendNotificationActivity.execute!(result)

    if workflow.has_release?(:activity_c)
      result = ActivityC.execute!(result)
    end
    logger.info "Hello, #{result}!"
  end
end
