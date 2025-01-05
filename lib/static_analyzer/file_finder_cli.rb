require "./lib/static_analyzer/temporal_files_finder"

class FileFinderCLI
  def self.run(rails_root = ".")
    finder = TemporalFilesFinder.new(rails_root)
    report = finder.find_files

    puts "\nWorkflow Files Found: #{report[:stats][:total_workflows]}".blue
    puts "====================".blue
    report[:workflows].each do |file|
      puts "- #{file}"
    end

    puts "\nActivity Files Found: #{report[:stats][:total_activities]}".green
    puts "====================".green
    report[:activities].each do |file|
      puts "- #{file}"
    end

    puts "\nSummary:".yellow
    puts "Total Temporal Files: #{report[:stats][:total_workflows] + report[:stats][:total_activities]}"

    report[:workflows] + report[:activities]
  end
end
