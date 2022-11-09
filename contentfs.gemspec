# frozen_string_literal: true

require File.expand_path("../lib/contentfs/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name = "contentfs"
  spec.version = ContentFS::VERSION
  spec.summary = "A structured content file system."
  spec.description = spec.summary

  spec.author = "Bryan Powell"
  spec.email = "bryan@bryanp.org"
  spec.homepage = "https://github.com/bryanp/contentfs/"

  spec.required_ruby_version = ">= 2.6.7"

  spec.license = "MIT"

  spec.files = Dir["CHANGELOG.md", "README.md", "LICENSE", "lib/**/*"]
  spec.require_path = "lib"
end
