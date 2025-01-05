require "./lib/static_analyzer/analyzer_cli"
require "./lib/static_analyzer/file_finder_cli"

namespace :temporal do
  desc "Start Temporal Analyzer"
  task static_analyzer: :environment do
    # AnalyzerCLI.run("app/activities/activity_a.rb")
    FileFinderCLI.run(".")
  end
end
