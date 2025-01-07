class ActivityC < Temporal::Activity
  def execute(name)
    sleep 5
    "#{name} -> Activity C"
  end
end
