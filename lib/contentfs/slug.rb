# frozen_string_literal: true

module ContentFS
  # @api private
  class Slug
    class << self
      SPECIAL_CHARACTER_REGEXP = /[^a-zA-Z0-9\-_]*/

      def build(value)
        value.to_s.gsub(SPECIAL_CHARACTER_REGEXP, "").to_sym
      end
    end
  end
end
