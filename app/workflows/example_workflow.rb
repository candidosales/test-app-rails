class ExampleWorkflow < Temporal::Workflow
  def execute(name)
    result = ActivityA.execute!(name)
    result = ActivityB.execute!(result)

    # result = Temporal.start_workflow(
    #   CardBWorkflow,
    #   input: result)


    # if workflow.has_release?(:activity_f)
    #   result = ActivityF.execute!(result)
    # end
    #
    # result = ActivityC.execute!(result)
    #
    result = Temporal.start_workflow(
      CardBWorkflow,
      input: result)

    score = nil
    workflow.on_signal("score") do |signal_value|
      score = signal_value
    end

    workflow.wait_until { score }


    logger.info "Hello, #{result}!"
  end
end
