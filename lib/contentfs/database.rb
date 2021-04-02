# frozen_string_literal: true

require "pathname"

require_relative "content"
require_relative "prefix"
require_relative "slug"

module ContentFS
  # Structured content database, loaded from the filesystem.
  #
  class Database
    class << self
      def load(path, parent: nil, namespace: [], root: true, &block)
        new(path: path, parent: parent, namespace: namespace, root: root, &block)
      end
    end

    METADATA_FILE = "_metadata.yml"

    attr_reader :prefix, :slug, :namespace, :metadata

    def initialize(path:, parent: nil, namespace: [], root: false, &block)
      path = Pathname.new(path)
      name = path.basename(path.extname)
      prefix, remainder = Prefix.build(name)
      @prefix = prefix
      @namespace = namespace.dup
      @parent = parent

      unless root
        @slug = Slug.build(remainder)
        @namespace << @slug
      end

      metadata_path = path.join(METADATA_FILE)

      @metadata = if metadata_path.exist?
        YAML.safe_load(metadata_path.read).to_h
      else
        {}
      end

      content_path = path.join.glob("_content.*")[0]

      @content = if content_path&.exist?
        Content.load(content_path, database: self, metadata: @metadata, namespace: @namespace, &block)
      end

      children, nested, includes = {}, {}, {}
      Pathname.new(path).glob("*") do |path|
        underscored = path.basename.to_s.start_with?("_")
        next if underscored && path.directory?

        if path.directory?
          database = Database.load(path, parent: self, namespace: @namespace, root: false, &block)
          nested[database.slug] = database
        elsif underscored
          content = Content.load(path, database: self, metadata: @metadata, namespace: @namespace, &block)

          includes[content.slug.to_s[1..].to_sym] = content
        else
          content = Content.load(path, database: self, metadata: @metadata, namespace: @namespace, &block)

          children[content.slug] = content
        end
      end

      @children = Hash[
        children.sort_by { |key, content|
          (content.prefix || content.slug).to_s
        }
      ]

      @nested = Hash[
        nested.sort_by { |key, database|
          (database.prefix || database.slug).to_s
        }
      ]

      @includes = Hash[
        includes.sort_by { |key, content|
          (content.prefix || content.slug).to_s
        }
      ]
    end

    def content
      return to_enum(:content) unless block_given?

      @children.each_value do |value|
        yield value
      end
    end

    def nested
      return to_enum(:nested) unless block_given?

      @nested.each_value do |value|
        yield value
      end
    end

    def filter(**filters)
      return to_enum(:filter, **filters) unless block_given?

      filters = filters.each_with_object({}) { |(key, value), hash|
        hash[key.to_s] = value
      }

      @children.each_value.select { |content|
        yield content if content.metadata.all? { |key, value|
          filters[key] == value
        }
      }
    end

    def find(name, *nested)
      if @children.key?(name)
        @children[name]
      elsif @nested.key?(name)
        nested.inject(@nested[name]) { |database, next_nested|
          database.find(next_nested.to_sym)
        }
      end
    end

    def find_include(path)
      @includes[path.to_sym] || find_child_include(path) || find_parent_include(path) || find_include_from_toplevel(path)
    end

    def toplevel
      @parent ? @parent.toplevel : self
    end

    private def find_child_include(path)
      return unless path.include?("/")

      path_parts = path.split("/", 2)
      @nested[path_parts[0].to_sym]&.find_include(path_parts[1])
    end

    private def find_parent_include(path)
      return if @parent.nil?
      return unless path.start_with?("../")

      path_parts = path.split("../", 2)
      @parent.find_include(path_parts[1])
    end

    private def find_include_from_toplevel(path)
      return if @parent.nil?

      toplevel.find_include(path)
    end

    def to_s
      @content&.to_s.to_s
    end

    def render
      @content&.render
    end

    def method_missing(name, *nested, **)
      find(name, *nested) || super
    end

    def respond_to_missing?(name, *)
      @children.key?(name) || super
    end
  end
end
