class ActivityF < Temporal::Activity
  def execute(name)
    sleep 15
    "#{name} -> Activity F"
  end
end
