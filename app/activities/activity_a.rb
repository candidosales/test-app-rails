class ActivityA < Temporal::Activity
  def execute(name)
    current_time = Time.now
    "#{name} from Activity A"
  end
end
