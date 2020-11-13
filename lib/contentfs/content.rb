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
      def load(path, metadata: {}, namespace: [])
        new(path: path, metadata: metadata, namespace: namespace)
      end
    end

    FRONT_MATTER_REGEXP = /\A---\s*\n(.*?\n?)^---\s*$\n?/m

    attr_reader :format, :prefix, :slug, :metadata, :namespace

    def initialize(path:, metadata: {}, namespace: [])
      path = Pathname.new(path)
      extname = path.extname
      name = path.basename(extname)
      prefix, remainder = Prefix.build(name)
      @prefix = prefix
      @format = extname.to_s[1..-1]&.to_sym
      @slug = Slug.build(remainder)
      @content = path.read
      @metadata = metadata.merge(parse_metadata(@content))
      @namespace = namespace.dup << @slug
    end

    def to_s
      @content
    end

    def render
      if @format && (renderer = Renderers.resolve(@format))
        renderer.render(@content)
      else
        to_s
      end
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
