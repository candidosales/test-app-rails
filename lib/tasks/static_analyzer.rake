require "./lib/static_analyzer/analyzer_cli"

namespace :temporal do
  desc "Start Temporal Analyzer"
  task static_analyzer: :environment do
    # AnalyzerCLI.run("app/activities/activity_a.rb")
  end
end
