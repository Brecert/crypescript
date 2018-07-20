module Crypescript
  module Conditionals
    def transpile(node : Crystal::If)
      condition = transpile(node.cond)
      io = IO::Memory.new
      io << "if ("

      case node
      when Crystal::Unless
        io << "!"
      end

      io << "#{condition}"
      io << ") {"

      io << "\n#{node.then}\n"
      io << "}"
      io.to_s
    end
  end
end
