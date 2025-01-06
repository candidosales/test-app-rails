class ActivityD < Temporal::Activity
  def execute(name)
    sleep 15
    "#{name} -> Activity D"
  end
end
