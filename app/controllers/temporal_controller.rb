class TemporalController < ApplicationController
  def create
    # workflow_id = "#{params[:name]}-#{SecureRandom.uuid}"
    result = Temporal.start_workflow(
      ExampleWorkflow,
      input: params[:name])
    render plain: "Workflow started with name: #{params[:name]}, workflow_id: #{result}"
  end
end
