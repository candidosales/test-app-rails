require "pathname"
require "colorize"

class TemporalFilesFinder
  def initialize(rails_root)
    @rails_root = Pathname.new(rails_root)
    @workflow_files = []
    @activity_files = []
  end

  def find_files
    # Get all Ruby files in the project
    ruby_files = Dir.glob(@rails_root.join("**", "*.rb"))
      .reject { |f| excluded_path?(f) }
      .map { |f| Pathname.new(f) }

    ruby_files.each do |file|
      relative_path = file.relative_path_from(@rails_root).to_s

      if workflow_file?(relative_path)
        @workflow_files << relative_path
      elsif activity_file?(relative_path)
        @activity_files << relative_path
      end
    end

    build_report
  end

  private

  def excluded_path?(path)
    excluded_directories = %w[vendor tmp node_modules coverage log]
    excluded_directories.any? { |dir| path.include?("/#{dir}/") }
  end

  def workflow_file?(path)
    path.downcase.include?("workflow")
  end

  def activity_file?(path)
    path.downcase.include?("activity")
  end

  def build_report
    {
      workflows: @workflow_files.sort,
      activities: @activity_files.sort,
      stats: {
        total_workflows: @workflow_files.size,
        total_activities: @activity_files.size
      }
    }
  end
end
