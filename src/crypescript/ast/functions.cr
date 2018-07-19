module Crypescript
  module Functions
    def transpile(method : Crystal::Def)
      context = CURRENT_CONTEXT.last

      if context == :class
        dinc = Crypescript::AST::DefInClass.new(method.name, method.args, method.body, method.receiver, method.block_arg, method.return_type, method.macro_def?, method.yields, method.abstract?, method.splat_index, method.double_splat, method.free_vars)
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
      io << " {\n #{transpile node.body} \n}"
      io.to_s
    end
  end
end
