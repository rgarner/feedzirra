module Feedzirra
  module Parser
    class AtomContent
      include SAXMachine
      attribute :type
      value :body

      def to_s
        body
      end

      def to_str
        to_s
      end

      def +(other)
        self.to_s + other.to_s
      end
    end
  end
end