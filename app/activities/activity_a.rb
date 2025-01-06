class ActivityA < Temporal::Activity
  def execute(name)
    # current_time = Time.now
    "#{name} -> Activity A"
  end
end
