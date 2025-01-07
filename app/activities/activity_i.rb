class ActivityI < Temporal::Activity
  def execute(name)
    sleep 5
    "#{name} -> Activity I"
  end
end
