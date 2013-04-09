module Feedzirra
  module Parser
    class AtomLink
      include SAXMachine
      attribute :href
      attribute :rel

      def to_s
        href
      end
    end
  end
end