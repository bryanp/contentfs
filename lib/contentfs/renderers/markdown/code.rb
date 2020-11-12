# frozen_string_literal: true

require "rouge"
require "rouge/plugins/redcarpet"

require_relative "../markdown"

module ContentFS
  module Renderers
    class Markdown
      # @api private
      class Code
        class << self
          def render(content)
            renderer.render(content)
          end

          private def renderer
            @_renderer ||= Redcarpet::Markdown.new(Renderer, Markdown.options)
          end
        end

        class Renderer < Markdown::Renderer
          include Rouge::Plugins::Redcarpet
        end
      end
    end
  end
end
