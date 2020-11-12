# frozen_string_literal: true

require File.expand_path("../lib/contentfs/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name = "contentfs"
  spec.version = ContentFS::VERSION
  spec.summary = "A structured content file system."
  spec.description = spec.summary

  spec.author = "Bryan Powell"
  spec.email = "bryan@metabahn.com"
  spec.homepage = "https://github.com/metabahn/contentfs/"

  spec.required_ruby_version = ">= 2.5.0"

  spec.license = "MIT"

  spec.files = Dir["CHANGELOG.md", "README.md", "LICENSE", "lib/**/*"]
  spec.require_path = "lib"
end
