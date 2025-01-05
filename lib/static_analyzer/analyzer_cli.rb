require "./lib/static_analyzer/temporal_static_analyzer"

class NonDeterministicError < StandardError
  attr_reader :file_path, :issues

  def initialize(issues, file_path)
    @issues = issues
    @file_path = file_path
    message = build_error_message(issues)
    super(message)
  end

  private

  def build_error_message(issues)
    messages = [ "Found #{issues.size} non-deterministic issues:" ]

    issues.each do |issue|
      messages << "\nType: #{issue[:type]}"
      messages << "Message: #{issue[:message]}"
      messages << "Location: #{issue[:location][:class]}##{issue[:location][:method]} -> #{file_path}"
    end

    messages.join("\n")
  end
end

class AnalyzerCLI
  def self.run(file_path)
    code = File.read(file_path)
    analyzer = TemporalStaticAnalyzer.new(code)
    issues = analyzer.analyze

    if !issues.empty?
      raise NonDeterministicError.new(issues, file_path)
    end

    issues # Success exit code

  rescue NonDeterministicError => e
    puts "\nError: #{e.message}".red
    1 # Failure exit code
  rescue StandardError => e
    puts "\nError analyzing temporal files: #{e.message}".red
    puts e.backtrace
    2 # Critical failure exit code

    # if issues.empty?
    #   puts "No non-deterministic issues found!"
    # else
    #   puts "\nFound #{issues.size} at #{file_path} potential non-deterministic issues:".yellow
    #   issues.each do |issue|
    #     puts "Type: #{issue[:type]}".yellow
    #     puts "Message: #{issue[:message]}".yellow
    #     puts "Location: #{issue[:location][:class]}##{issue[:location][:method]}".yellow
    #     puts "\n\n"
    #   end
    # end
  end
end
