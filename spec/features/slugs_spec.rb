# frozen_string_literal: true

require "contentfs"

RSpec.describe "content and database slugs" do
  let(:database) {
    ContentFS::Database.load(path)
  }

  let(:path) {
    File.expand_path("../slugs/support/content", __FILE__)
  }

  it "exposes slugs for content" do
    expect(database.foo.slug).to eq(:foo)
  end

  it "exposes slugs for databases" do
    expect(database.bar.slug).to eq(:bar)
  end

  it "ignores the prefix for content lookup" do
    expect(database.prefixed.slug).to eq(:prefixed)
  end

  it "ignores the prefix for database lookup" do
    expect(database.bar.prefixed.slug).to eq(:prefixed)
  end

  it "removes special characters from content slugs" do
    expect(database.special_foo.slug).to eq(:special_foo)
  end

  it "removes special characters from database slugs" do
    expect(database.bar.special.slug).to eq(:special)
  end
end
