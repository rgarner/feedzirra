module Feedzirra
  module Parser
    class AtomLink
      include SAXMachine
      attribute :href, :as => :escaped_href
      attribute :rel
      attribute :type

      def href
        CGI.unescapeHTML escaped_href
      end

      def to_s
        href
      end
    end
  end
end