module Crypescript
  module Classes
    def transpile(klass : Crystal::ClassDef)
      CURRENT_CONTEXT.push :class
      io = IO::Memory.new
      io << "class #{klass.name}"
      io << " extends #{klass.superclass}" if klass.superclass
      io << " {\n"
      io << transpile klass.body
      io << "\n}"
      CURRENT_CONTEXT.pop
      io.to_s
    end

    def transpile(node : Crystal::Self)
      "this"
    end

    # When a new class is instanced
    def transpile(node : AST::New)
      io = IO::Memory.new
      io << "#{node.name} #{node.obj}"
      io << "(#{node.args.join(", ")})" if !node.args.empty?
      io.to_s
    end
  end
end
