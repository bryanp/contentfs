# frozen_string_literal: true

module ContentFS
  module Renderers
    class << self
      def resolve(format)
        renderers[format.to_sym].to_a.each do |renderer|
          if (resolved = try(renderer))
            return resolved
          end
        end

        nil
      end

      def register(name, format:, constant:, path:)
        (renderers[format.to_sym] ||= []) << {
          name: name.to_sym,
          constant: constant.to_s,
          path: Pathname.new(path)
        }
      end

      # @api private
      private def try(renderer)
        require(renderer[:path])
        const_get(renderer[:constant])
      rescue LoadError
        # swallow load errors
      rescue NameError
        # TODO: maybe print name errors
      rescue
        # TODO: maybe print other errors
      end

      # @api private
      private def renderers
        @_renderers ||= {}
      end
    end
  end
end

ContentFS::Renderers.register(
  :markdown_code,
  format: :md,
  constant: "ContentFS::Renderers::Markdown::Code",
  path: File.expand_path("../renderers/markdown/code", __FILE__)
)

ContentFS::Renderers.register(
  :markdown,
  format: :md,
  constant: "ContentFS::Renderers::Markdown",
  path: File.expand_path("../renderers/markdown", __FILE__)
)
