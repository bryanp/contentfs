# frozen_string_literal: true

require "contentfs"

RSpec.describe "iterating over content in a database" do
  let(:database) {
    ContentFS::Database.load(path)
  }

  let(:path) {
    File.expand_path("../iterating/support/content", __FILE__)
  }

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
