require "parser/current"
require "ast"

class TemporalStaticAnalyzer
  class NonDeterministicError < StandardError; end

  POTENTIAL_ISSUES = {
    random: [ "Random", "SecureRandom", "rand", "srand" ],
    time: [ "Time.now", "DateTime.now", "Date.today" ],
    uuid: [ "SecureRandom.uuid", "UUID.generate" ],
    global_state: [ "@@", "$" ],
    direct_io: [ "File", "Dir", "IO" ]
  }

  def initialize(code)
    @code = code
    @issues = []
    @current_class = nil
    @current_method = nil
  end

  def analyze
    ast = Parser::CurrentRuby.parse(@code)
    process_node(ast)
    @issues
  end

  private

  def process_node(node)
    return unless node.is_a?(AST::Node)

    case node.type
    when :class
      handle_class_definition(node)
    when :def
      handle_method_definition(node)
    when :const
      check_constant(node)
    when :send
      check_method_call(node)
    when :ivar, :cvar, :gvar
      check_variable(node)
    end

    # Recursively process child nodes
    node.children.each { |child| process_node(child) }
  end

  def handle_class_definition(node)
    class_name = node.children[0].children[1].to_s
    @current_class = class_name

    # Check if it's a workflow or activity
    if class_name.end_with?("Workflow", "Activity")
      process_node(node.children.last)
    end
  end

  def handle_method_definition(node)
    @current_method = node.children[0].to_s
  end

  def check_constant(node)
    const_name = node.children[1].to_s

    POTENTIAL_ISSUES.each do |issue_type, patterns|
      if patterns.any? { |pattern| const_name.include?(pattern) }
        add_issue(issue_type, "Use of potentially non-deterministic constant: #{const_name}")
      end
    end
  end

  def check_method_call(node)
    return unless node.children[1]

    method_name = node.children[1].to_s
    receiver = node.children[0]

    if receiver && receiver.type == :const
      full_call = "#{receiver.children[1]}.#{method_name}"

      POTENTIAL_ISSUES.each do |issue_type, patterns|
        if patterns.any? { |pattern| full_call.include?(pattern) }
          add_issue(issue_type, "Potentially non-deterministic method call: #{full_call}")
        end
      end
    end
  end

  def check_variable(node)
    var_name = node.children[0].to_s

    if var_name.start_with?("@@", "$")
      add_issue(:global_state, "Use of non-deterministic global/class variable: #{var_name}")
    end
  end

  def add_issue(type, message)
    @issues << {
      type: type,
      message: message,
      location: {
        class: @current_class,
        method: @current_method
      }
    }
  end
end
