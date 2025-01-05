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
        if ast
          # Process the entire AST to find registrations
          process_node_for_registrations(ast, file)
        end
      rescue Parser::SyntaxError => e
        puts "Syntax error in #{file}: #{e.message}"
      end
    end
  end

  def process_node_for_registrations(node, file, in_worker_block = false)
    return unless node.is_a?(Parser::AST::Node)

    # Check if this node initializes a Temporal worker
    if temporal_worker_initialization?(node)
      @worker_files << file
      in_worker_block = true
    end

    # If we're in a worker block, check for registrations
    if in_worker_block && registration_node?(node)
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

    # Recursively process all children with the current worker block state
    node.children.each do |child|
      process_node_for_registrations(child, file, in_worker_block)
    end
  end

  def temporal_worker_initialization?(node)
    return false unless node.type == :send

    # Match both direct initialization and assignment
    # worker = Temporal::Worker.new
    # Temporal::Worker.new
    if node.children[1] == :new
      receiver = node.children[0]
      return temporal_worker_constant?(receiver)
    end

    # Match assignment to worker variable
    if node.type == :lvasgn && node.children[0] == :worker
      value = node.children[1]
      return value && value.type == :send && temporal_worker_constant?(value.children[0])
    end

    false
  end

  def temporal_worker_constant?(node)
    return false unless node&.type == :const

    # Check for Temporal::Worker
    parent = node.children[0]
    return false unless parent&.type == :const
    return false unless parent.children[1] == :Temporal

    node.children[1] == :Worker
  end

  def process_registration_block(node, file)
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

    node.children.each { |child| process_registration_block(child, file) }
  end

  def registration_node?(node)
    node.type == :send &&
      [ :register_workflow, :register_activity ].include?(node.children[1])
  end

  def ruby_files
    Dir.glob(@rails_root.join("**", "*.{rb,rake}"))
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
