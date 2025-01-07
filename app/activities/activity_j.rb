class ActivityJ < Temporal::Activity
  def execute(name)
    sleep 5
    "#{name} -> Activity J"
  end
end
