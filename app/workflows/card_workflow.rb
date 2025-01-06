class CardWorkflow < Temporal::Workflow
  def execute(name)
    result = SendNotificationActivity.execute!(name)
    logger.info "Send notification, #{result}!"
  end
end
