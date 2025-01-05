require "./lib/static_analyzer/temporal_static_analyzer"

class AnalyzerCLI
  def self.run(file_path)
    code = File.read(file_path)
    analyzer = TemporalStaticAnalyzer.new(code)
    issues = analyzer.analyze

    if issues.empty?
      puts "No non-deterministic issues found!"
    else
      puts "\nFound #{issues.size} at #{file_path} potential non-deterministic issues:".yellow
      issues.each do |issue|
        puts "Type: #{issue[:type]}".yellow
        puts "Message: #{issue[:message]}".yellow
        puts "Location: #{issue[:location][:class]}##{issue[:location][:method]}".yellow
        puts "\n\n"
      end
    end
  end
end
