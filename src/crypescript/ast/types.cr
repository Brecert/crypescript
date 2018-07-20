module Crypescript
  module Types
    def transpile(node : Crystal::Generic)
      @@log.debug "Generic: #{node}"
      "#{node.name}: #{node.type_vars}"
    end

    def transpile(node : Crystal::TypeDeclaration)
      @@log.debug "TYPEDEC: #{CURRENT_CONTEXT.last} #{@@variables[node.var.to_s]?}"

      io = IO::Memory.new
      if @@variables[node.var.to_s]?
        if !@@variables[node.var.to_s].global
          io << "let " unless CURRENT_CONTEXT.last === :class
        end
      else
        io << "let " unless CURRENT_CONTEXT.last === :class
      end

      @@variables[node.var.to_s] = Crypescript::Variable.new(node.var.to_s, node.value)

      io << node.var.to_s
      io << ": #{transpile node.declared_type}"
      io << " = #{transpile node.value}" if !node.value.nil?
      io.to_s
    end

    def translate_type(value : String)
      case value
      when "Number", "Crystal::NumberLiteral"
        "number"
      when "String", "Crystal::StringLiteral"
        "string"
      when "Any"
        "any"
      when "Nil", "Crystal::Nop"
        "null"
      else
        value
      end
    end
  end
end
