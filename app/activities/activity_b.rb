class ActivityB < Temporal::Activity
  def execute(name)
    sleep 10
    "#{name} from Activity B"
  end
end
