require "parser/current"
require "pathname"

class TemporalPathAnalyzer
  def initialize(rails_root)
    @rails_root = Pathname.new(rails_root)
    @registrations = []
    @worker_files = []
    @class_definitions = {}
  end

  def analyze
    # First pass: find all class definitions and their file locations
    find_all_class_definitions

    # Second pass: find all Temporal worker registrations
    find_worker_registrations

    # Build the final report
    build_report
  end

  private

  def find_all_class_definitions
    ruby_files.each do |file|
      content = File.read(file)
      begin
        ast = Parser::CurrentRuby.parse(content)
        process_class_definitions(ast, file) if ast
      rescue Parser::SyntaxError => e
        puts "Syntax error in #{file}: #{e.message}"
      end
    end
  end

  def process_class_definitions(node, file, namespace = [])
    return unless node.is_a?(Parser::AST::Node)

    if node.type == :class
      class_name = extract_class_name(node)
      full_name = (namespace + [ class_name ]).join("::")
      @class_definitions[full_name] = file.relative_path_from(@rails_root).to_s

      # Process nested classes
      process_class_definitions(node.children.last, file, namespace + [ class_name ])
    end

    node.children.each do |child|
      process_class_definitions(child, file, namespace)
    end
  end

  def find_worker_registrations
    ruby_files.each do |file|
      content = File.read(file)
      begin
        ast = Parser::CurrentRuby.parse(content)
        process_worker_registrations(ast, file) if ast
      rescue Parser::SyntaxError => e
        puts "Syntax error in #{file}: #{e.message}"
      end
    end
  end

  def process_worker_registrations(node, file)
    return unless node.is_a?(Parser::AST::Node)

    if temporal_worker_initialization?(node)
      @worker_files << file
      process_registration_block(node, file)
    end

    node.children.each { |child| process_worker_registrations(child, file) }
  end

  def temporal_worker_initialization?(node)
    return false unless node.type == :send

    receiver = node.children[0]
    method_name = node.children[1]

    receiver &&
      receiver.type == :const &&
      receiver.children[1] == :Temporal &&
      method_name == :new
  end

  def process_registration_block(node, file)
    parent = node.parent
    while parent
      if parent.type == :block
        find_registrations(parent, file)
      end
      parent = parent.parent
    end
  end

  def find_registrations(node, file)
    return unless node.is_a?(Parser::AST::Node)

    if node.type == :send && [ :register_workflow, :register_activity ].include?(node.children[1])
      registration_type = node.children[1]
      class_name = extract_registration_class_name(node)

      if class_name
        @registrations << {
          type: registration_type,
          class_name: class_name,
          worker_file: file.relative_path_from(@rails_root).to_s,
          class_file: @class_definitions[class_name]
        }
      end
    end

    node.children.each { |child| find_registrations(child, file) }
  end

  def ruby_files
    Dir.glob(@rails_root.join("**", "*.rb"))
      .reject { |f| f.include?("/vendor/") || f.include?("/tmp/") }
      .map { |f| Pathname.new(f) }
  end

  def extract_class_name(node)
    return unless node.children[0].is_a?(Parser::AST::Node)
    node.children[0].children[1].to_s
  end

  def extract_registration_class_name(node)
    return unless node.children[2].is_a?(Parser::AST::Node)

    if node.children[2].type == :const
      node.children[2].children[1].to_s
    end
  end

  def build_report
    {
      worker_files: @worker_files.map { |f| f.relative_path_from(@rails_root).to_s },
      workflows: @registrations.select { |r| r[:type] == :register_workflow },
      activities: @registrations.select { |r| r[:type] == :register_activity }
    }
  end
end

# Example usage class
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
