namespace :scheduler do
  desc "Calls workflow method every 6 seconds"
  task run_periodic_task: :environment do
    loop do
      current_time = Time.now
      TemporalService.start_workflow(input: "test-#{current_time}")
      puts "Task successfully executed at #{current_time}"
      sleep 6 # Pause for 6 seconds
    end
  end
end
