module Feedzirra
  module Parser
    class AtomContent
      include SAXMachine
      attribute :type
      value :body

      def to_s
        body
      end
    end
  end
end