class TemporalController < ApplicationController
  def create
    result = TemporalService.start_workflow(input: params[:name])
    render plain: "ExampleWorkflow started with name: #{params[:name]}, workflow_id: #{result}"
  end

  def notification
    result = Temporal.start_workflow(
      NotificationWorkflow,
      input: params[:name])
    render plain: "NotificationWorkflow started with name: #{params[:name]}, workflow_id: #{result}"
  end
end
