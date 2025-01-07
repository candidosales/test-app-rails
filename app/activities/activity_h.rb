class ActivityH < Temporal::Activity
  def execute(name)
    sleep 5
    "#{name} -> Activity H"
  end
end
