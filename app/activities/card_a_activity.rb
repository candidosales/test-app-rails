class CardAActivity < Temporal::Activity
  def execute(name)
    sleep 5
    "#{name} -> CardActivity"
  end
end
