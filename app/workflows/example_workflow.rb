class ExampleWorkflow < Temporal::Workflow
  def execute(name)
    result = ActivityA.execute!(name)
    result = ActivityB.execute!(result)
    # result = SendNotificationActivity.execute!(result)
    # result = Temporal.start_workflow(
    #   NotificationWorkflow,
    #   input: name)

    if workflow.has_release?(:activity_c)
      result = ActivityC.execute!(result)
    end

    if workflow.has_release?(:activity_d)
      result = ActivityD.execute!(result)
    end

    if workflow.has_release?(:activity_e)
      result = ActivityE.execute!(result)
    end

    logger.info "Hello, #{result}!"
  end
end
