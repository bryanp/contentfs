# frozen_string_literal: true

module ContentFS
  # @api private
  class Prefix
    class << self
      def build(value)
        parts = value.to_s.split("__", 2)

        case parts.length
        when 2
          parts
        when 1
          [nil, parts[0]]
        end
      end
    end
  end
end
