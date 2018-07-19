module Crypescript
  module Expressions
    def transpile(node : Crystal::Expressions)
      node.expressions.map do |e|
        @@log.debug "#{e.class} : #{e}"
        transpile e
      end.join("\n")
    end
  end
end
