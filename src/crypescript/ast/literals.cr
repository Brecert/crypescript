module Crypescript
  module Literals
    def transpile(node : Crystal::ArrayLiteral)
      elements = transpile(node.elements).join(", ")

      array_type = node.of
      case array_type
      when Crystal::Path
        "[#{elements}]"
      else
        "[#{elements}]"
      end
    end
  end
end
