class ActivityA < Temporal::Activity
  def execute(name)
    "#{name} from Activity A"
  end
end
