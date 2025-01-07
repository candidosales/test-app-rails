class ActivityL < Temporal::Activity
  def execute(name)
    sleep 5
    "#{name} -> Activity L"
  end
end
