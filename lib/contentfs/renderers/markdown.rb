# frozen_string_literal: true

require "commonmarker"

module ContentFS
  module Renderers
    # @api private
    class Markdown
      class << self
        def render(content)
          renderer.render(CommonMarker.render_doc(content))
        end

        private def renderer
          ContentFSRenderer.new(options: [:DEFAULT, :UNSAFE])
        end
      end

      class ContentFSRenderer < CommonMarker::HtmlRenderer
        def blockquote(node)
          blockquote_type = if (match = node.to_plaintext.strip.match(/\[(.*)\]/))
            match[1]
          end

          blockquote_class = if blockquote_type
            " class=\"#{blockquote_type}\""
          end

          block do
            container("<blockquote#{sourcepos(node)}#{blockquote_class}>\n", "</blockquote>") do
              node.each.with_index do |child, index|
                content = if blockquote_class && index == 0
                  child.to_html.gsub("<p>[#{blockquote_type}] ", "<p>")
                else
                  child
                end

                out(content)
              end
            end
          end
        end
      end
    end
  end
end
