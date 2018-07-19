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
  end
end
