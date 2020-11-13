# frozen_string_literal: true

require "contentfs"

RSpec.describe "prefixed content paths" do
  let(:database) {
    ContentFS::Database.load(path)
  }

  let(:path) {
    File.expand_path("../prefixed/support/content", __FILE__)
  }

  it "exposes the prefix for content" do
    expect(database.find(:foo).prefix).to eq("0000")
  end

  it "exposes the prefix for databases" do
    expect(database.find(:nested).prefix).to eq("0001")
  end
end
