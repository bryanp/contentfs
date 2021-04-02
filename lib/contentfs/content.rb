# frozen_string_literal: true

require "pathname"
require "yaml"

require_relative "renderers"
require_relative "prefix"
require_relative "slug"

module ContentFS
  # Structured content, loaded from the filesystem and usually exposed through a database.
  #
  class Content
    class << self
      def load(path, database:, metadata: {}, namespace: [], &block)
        new(path: path, database: database, metadata: metadata, namespace: namespace, &block)
      end
    end

    FRONT_MATTER_REGEXP = /\A---\s*\n(.*?\n?)^---\s*$\n?/m
    INCLUDE_REGEXP = /<!-- @include\s*([a-zA-Z0-9\-_\/.]*) -->/

    attr_reader :format, :prefix, :slug, :metadata, :namespace

    def initialize(path:, database:, metadata: {}, namespace: [], &block)
      path = Pathname.new(path)
      extname = path.extname
      name = path.basename(extname)
      prefix, remainder = Prefix.build(name)
      @prefix = prefix
      @format = extname.to_s[1..]&.to_sym
      @slug = Slug.build(remainder)
      @namespace = namespace.dup << @slug
      @database = database

      content = path.read
      content = block.call(content) if block
      @metadata = metadata.merge(parse_metadata(content))
      @content = content.gsub(FRONT_MATTER_REGEXP, "")
    end

    def to_s
      @content
    end

    def render
      if @format && (renderer = Renderers.resolve(@format))
        resolve_includes(renderer.render(@content))
      else
        resolve_includes(to_s)
      end
    end

    private def resolve_includes(content)
      working_content = content.dup

      content.scan(INCLUDE_REGEXP) do |match|
        if (include = @database.find_include(match[0]))
          working_content.gsub!($~.to_s, include.render)
        end
      end

      working_content
    end

    private def parse_metadata(content)
      if (match = content.match(FRONT_MATTER_REGEXP))
        YAML.safe_load(match.captures[0]).to_h
      else
        {}
      end
    end
  end
end
