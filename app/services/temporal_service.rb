class TemporalService
  def self.start_workflow(input:)
    Temporal.start_workflow(ExampleWorkflow, input: input)
  end
end
