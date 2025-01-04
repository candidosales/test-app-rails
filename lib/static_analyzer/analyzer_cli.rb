require "./lib/static_analyzer/temporal_static_analyzer"

class AnalyzerCLI
  def self.run(file_path)
    code = File.read(file_path)
    analyzer = TemporalStaticAnalyzer.new(code)
    issues = analyzer.analyze

    if issues.empty?
      puts "No non-deterministic issues found!"
    else
      puts "Found #{issues.size} potential non-deterministic issues:"
      issues.each do |issue|
        puts "\nType: #{issue[:type]}"
        puts "Message: #{issue[:message]}"
        puts "Location: #{issue[:location][:class]}##{issue[:location][:method]}"
      end
    end
  end
end
