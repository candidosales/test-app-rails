class SendNotificationActivity < Temporal::Activity
  def execute(name)
    sleep 5
    "#{name} -> SendNotificationActivity"
  end
end
