class ExampleWorkflow < Temporal::Workflow
  def execute(name)
    result = ActivityA.execute!(name)
    result = ActivityB.execute!(result)
    logger.info "Hello, #{result}!"
  end
end
