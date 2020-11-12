# frozen_string_literal: true

require "redcarpet"

module ContentFS
  module Renderers
    # @api private
    class Markdown
      class << self
        OPTIONS = {
          autolink: true,
          footnotes: true,
          fenced_code_blocks: true,
          tables: true
        }.freeze

        def render(content)
          renderer.render(content)
        end

        def options
          OPTIONS
        end

        private def renderer
          @_renderer ||= Redcarpet::Markdown.new(Renderer, options)
        end
      end

      class Renderer < Redcarpet::Render::HTML
        def block_quote(quote)
          if (match = quote.match(/<p>\[(.*)\]/))
            %(<blockquote class="#{match[1]}">#{quote.gsub("[#{match[1]}]", "")}</blockquote>)
          else
            super
          end
        end
      end
    end
  end
end
