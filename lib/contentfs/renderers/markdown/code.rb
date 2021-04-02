# frozen_string_literal: true

require "rouge"

require_relative "../markdown"

module ContentFS
  module Renderers
    class Markdown
      # @api private
      class Code
        class << self
          def render(content)
            renderer.render(CommonMarker.render_doc(content))
          end

          private def renderer
            SyntaxRenderer.new(options: [:DEFAULT, :UNSAFE])
          end
        end

        class SyntaxRenderer < CommonMarker::HtmlRenderer
          def code_block(node)
            block do
              language = node.fence_info.split(/\s+/)[0]
              out("<div class=\"highlight\"><pre class=\"highlight #{language}\"><code>")
              out(syntax_highlight(node.string_content, language))
              out('</code></pre></div>')
            end
          end

          private def syntax_highlight(source, language)
            if (lexer = Rouge::Lexer.find(language))
              Rouge::Formatters::HTML.new.format(lexer.lex(source))
            else
              source
            end
          end
        end
      end
    end
  end
end
