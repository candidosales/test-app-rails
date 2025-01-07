class CardBWorkflow < Temporal::Workflow
  def execute(name)
    result = CardBActivity.execute!(name)
    logger.info "Card B, #{result}!"
  end
end
