class CardWorkflow < Temporal::Workflow
  def execute(name)
    result = CardActivity.execute!(name)
    logger.info "Card, #{result}!"
  end
end
