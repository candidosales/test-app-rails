class CardAWorkflow < Temporal::Workflow
  def execute(name)
    result = CardAActivity.execute!(name)
    logger.info "Card A, #{result}!"
  end
end
