# frozen_string_literal: true

require "contentfs"

RSpec.describe "content format" do
  let(:database) {
    ContentFS::Database.load(path)
  }

  let(:path) {
    File.expand_path("../format/support/content", __FILE__)
  }

  it "exposes the format for the content" do
    expect(database.foo.format).to eq(:md)
  end
end
