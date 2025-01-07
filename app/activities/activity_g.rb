class ActivityG < Temporal::Activity
  def execute(name)
    sleep 10
    "#{name} -> Activity G"
  end
end
