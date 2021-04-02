# frozen_string_literal: true

require "commonmarker"

module ContentFS
  module Renderers
    # @api private
    class Markdown
      class << self
        def render(content)
          CommonMarker.render_html(content, [:DEFAULT, :UNSAFE])
        end
      end
    end
  end
end
