# frozen_string_literal: true

require "contentfs"

RSpec.describe "inspecting the namespace" do
  let(:database) {
    ContentFS::Database.load(path)
  }

  let(:path) {
    File.expand_path("../namespace/support/content", __FILE__)
  }

  it "gets the namespace for top-level databases" do
    expect(database.namespace).to eq([])
  end

  it "gets the namespace for nested databases" do
    expect(database.find(:bar).namespace).to eq([:bar])
  end

  it "gets the namespace for top-level content" do
    expect(database.find(:foo).namespace).to eq([:foo])
  end

  it "gets the namespace for nested content" do
    expect(database.find(:bar, :baz).namespace).to eq([:bar, :baz])
  end
end
