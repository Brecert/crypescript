module Crypescript
  module Modifiers
    def transpile(node : Crystal::VisibilityModifier)
      "#{node.modifier.to_s.downcase} #{transpile node.exp}"
    end
  end
end
