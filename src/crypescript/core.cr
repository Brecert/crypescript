module Crypescript
  module Core
    def transpile(node : String)
      node
    end

    def transpile(node : Crystal::ASTNode)
      node.to_s
    end

    def transpile(nodes : Array(Crystal::ASTNode) | Nil)
      case nodes
      when Nil
        [] of String
      else
        nodes.map do |node|
          transpile node
        end
      end
    end

    def transpile(node : Crystal::Nop)
      "Nop: #{node}"
    end
  end
end
