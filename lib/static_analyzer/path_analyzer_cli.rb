require "./lib/static_analyzer/temporal_path_analyzer"

class PathAnalyzerCLI
  def self.run(rails_root = ".")
    analyzer = TemporalPathAnalyzer.new(rails_root)
    report = analyzer.analyze

    puts "\nTemporal Worker Files:"
    puts "====================="
    report[:worker_files].each { |file| puts "- #{file}" }

    puts "\nRegistered Workflows:"
    puts "==================="
    report[:workflows].each do |workflow|
      puts "\nWorkflow: #{workflow[:class_name]}"
      puts "- Registered in: #{workflow[:worker_file]}"
      puts "- Defined in: #{workflow[:class_file] || 'Not found'}"
    end

    puts "\nRegistered Activities:"
    puts "===================="
    report[:activities].each do |activity|
      puts "\nActivity: #{activity[:class_name]}"
      puts "- Registered in: #{activity[:worker_file]}"
      puts "- Defined in: #{activity[:class_file] || 'Not found'}"
    end
  end
end
