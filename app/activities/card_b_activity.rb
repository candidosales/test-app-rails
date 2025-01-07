class CardBActivity < Temporal::Activity
  def execute(name)
    sleep 5
    "#{name} -> CardBActivity"
  end
end
