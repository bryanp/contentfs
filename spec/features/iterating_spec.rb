# frozen_string_literal: true

require "contentfs"

RSpec.describe "iterating through a database" do
  let(:database) {
    ContentFS::Database.load(path)
  }

  let(:path) {
    File.expand_path("../iterating/support/content", __FILE__)
  }

  describe "iterating over content" do
    it "returns an enum containing direct content" do
      iterator = database.content

      expect(iterator.count).to eq(2)
      expect(iterator.map(&:slug)).to eq([:foo, :bar])
    end

    it "iterates directly" do
      iterations = []
      database.content do |content|
        iterations << content.slug
      end

      expect(iterations).to eq([:foo, :bar])
    end
  end

  describe "iterating over nested databases" do
    it "returns an enum containing direct databases" do
      iterator = database.nested

      expect(iterator.count).to eq(1)
      expect(iterator.map(&:slug)).to eq([:sub])
    end

    it "iterates directly" do
      iterations = []
      database.nested do |database|
        iterations << database.slug
      end

      expect(iterations).to eq([:sub])
    end
  end
end
