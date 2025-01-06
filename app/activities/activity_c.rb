class ActivityC < Temporal::Activity
  def execute(name)
    sleep 10
    "#{name} -> Activity C"
  end
end
