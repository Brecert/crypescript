module Crypescript
  module Functions
    # Normal definition
    def transpile(method : Crystal::Def)
      context = CURRENT_CONTEXT.last

      if context == :class
        dinc = AST::DefInClass.new(method.name, method.args, method.body, method.receiver, method.block_arg, method.return_type, method.macro_def?, method.yields, method.abstract?, method.splat_index, method.double_splat, method.free_vars)
        return transpile(dinc)
      end

      CURRENT_CONTEXT.push :def
      name = method.name
      io = IO::Memory.new

      io << "function " if context != :class
      io << function_base(method, name)
      CURRENT_CONTEXT.pop
      io.to_s
    end

    # When defined in a class
    def transpile(method : AST::DefInClass)
      io = IO::Memory.new
      CURRENT_CONTEXT.push :def
      name = case method.name
             when "initialize"
               "constructor"
             else
               method.name
             end

      @@log.debug "#{name}"
      io << function_base(method, name)
      CURRENT_CONTEXT.pop
      io.to_s
    end

    macro copy_call(ast)
      AST::{{ast}}.new(call.obj, call.name, call.args, call.block, call.block_arg, call.named_args, call.global?, call.name_column_number, call.has_parentheses?)
    end

    def transpile(call : Crystal::Call)
      @@log.debug "Call: #{call.obj}.#{call.name}(#{call.args})"
      io = IO::Memory.new
      case call.name
      when "new"
        io << transpile copy_call(New)
      when "each"
        io << transpile copy_call(Each)
      when "[]="
        io << transpile copy_call(AssignArray)
      when /\W/
        io << "#{call.obj} #{call.name} #{transpile call.args.join(", ")}"
      else
        if call.obj.nil?
          io << "#{call.name}(#{call.args.join(", ")})"
        else
          io << "#{call.obj}.#{call.name}(#{call.args.join(", ")})"
        end
      end
      io.to_s
    end

    def function_base(node : Crystal::ASTNode, name)
      io = IO::Memory.new
      io << name

      args = node.args.map do |arg|
        argio = ""
        argio += "#{arg.name}"
        argio += ": #{transpile arg.restriction}" if !arg.restriction.nil?
        argio
      end

      io << "(#{args.join(", ")})"
      io << ": #{transpile node.return_type}" if !node.return_type.nil?
      io << " {\n"
      io << "#{transpile node.body}"
      io << "\n}"
      io.to_s
    end

    # Block
    def transpile(node : AST::Each)
      io = IO::Memory.new
      io << "for ("
      io << "#{node.block.as(Crystal::Block).args.map { |item| transpile(item) }.join(", ")} " unless node.block.nil?
      io << "#{transpile(Crystal::TypeDeclaration.new(Crystal::Var.new("temp"), Crystal::Path.new(["Any"])))} " if node.block.nil?
      io << "of #{transpile node.obj}"
      io << ") "
      io << '{'
      io << "\n#{transpile node.block.as(Crystal::Block).body}\n" unless node.block.nil?
      io << '}'
      io.to_s
    end
  end
end
