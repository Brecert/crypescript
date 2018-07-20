module Crypescript
  class Variable
    property name : String
    property value : Crystal::ASTNode | Nil
    property global : Bool

    def initialize(@name, @value, @global : Bool = false)
      @global = true if @name.starts_with? "@"
    end
    # property set_type : Crystal::ASTNode
  end

  module Variables
    # When assigning a variables
    # like `x = 10`
    def transpile(node : Crystal::Assign)
      io = IO::Memory.new
      variable = Variable.new(node.target.to_s, node.value)

      io << "let " if !@@variables[node.target.to_s]? && !variable.global
      io << "#{transpile(node.target)}"
      if variable.value.is_a?(Crystal::ArrayLiteral)
        io << ": #{node.value.as(Crystal::ArrayLiteral).of}[]"
      else
        io << ": #{transpile variable.value.class}" if !@@variables[node.target.to_s]? && !variable.global
      end
      io << " = "
      io << "#{transpile(variable.value)}"
      assign(node.target.to_s, variable)

      io.to_s
    end

    def transpile(node : AST::AssignArray)
      args = node.args.map do |arg|
        transpile arg
      end
      "#{node.obj}[#{node.args[0]}] = #{args[1..-1].join(", ")}"
    end

    def transpile(node : Crystal::OpAssign)
      value = Crystal::Call.new(node.target, node.op, node.value)
      transpile Crystal::Assign.new(node.target, value)
    end

    # When using var
    def transpile(node : Crystal::Var)
      # variable = get(node.name)
      "#{node.name}"
    end

    def transpile(node : Crystal::Global)
      # "this.#{node}"
      "GLOBAL: #{node}"
    end

    # Instance Var `@x`?
    def transpile(node : Crystal::InstanceVar)
      # get(node.name)
      "#{transpile Crystal::Self.new}.#{transpile(node.to_s.sub(/^@/, ""))}"
    end

    def assign(target : String, value : Crypescript::Variable)
      @@variables[target] = value
    end

    def get(target : String)
      @@variables[target]
    end
  end
end
