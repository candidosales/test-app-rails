class ActivityB < Temporal::Activity
  def execute(name)
    sleep 10
    "#{name} -> Activity B"
  end
end
