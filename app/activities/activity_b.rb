class ActivityB < Temporal::Activity
  def execute(name)
    sleep 100
    "#{name} from Activity B"
  end
end
