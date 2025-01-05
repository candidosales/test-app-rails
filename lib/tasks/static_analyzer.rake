require "./lib/static_analyzer/analyzer_cli"
require "./lib/static_analyzer/file_finder_cli"

namespace :temporal do
  desc "Start Temporal Analyzer"
  task static_analyzer: :environment do
    # AnalyzerCLI.run("app/activities/activity_a.rb")
    report_files = FileFinderCLI.run(".")

    puts "\nAnalyzing Temporal Files:".blue
    puts "====================".blue

    result = nil
    report_files.each do |file|
      result = AnalyzerCLI.run(file)
    end

    if result.empty?
      puts "\nNo issues found! Congrats!".green
    end
  end
end
