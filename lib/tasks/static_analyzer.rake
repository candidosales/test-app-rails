require "./lib/static_analyzer/analyzer_cli"
require "./lib/static_analyzer/file_finder_cli"

namespace :temporal do
  desc "Start Temporal Analyzer"
  task static_analyzer: :environment do
    # AnalyzerCLI.run("app/activities/activity_a.rb")
    report_files = FileFinderCLI.run(".")

    puts "\n====================".blue
    puts "Analyzing Temporal Files: \n".blue
    report_files.each do |file|
      AnalyzerCLI.run(file)
    end
  end
end
