module Crypescript
  module Paths
    def transpile(node : Crystal::Path)
      @@log.debug "Path: #{node} #{node.names.join(", ")}"

      translate_type(node.to_s)
    end
  end
end
