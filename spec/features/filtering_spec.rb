# frozen_string_literal: true

RSpec.describe "filtering content" do
  let(:database) {
    ContentFS::Database.load(path)
  }

  let(:path) {
    File.expand_path("../filtering/support/content", __FILE__)
  }

  it "filters content matching a single metadata value" do
    expect(database.filter(foo: "bar").count).to eq(1)
  end

  it "filters content matching multiple metadata values" do
    expect(database.filter(foo: "baz", baz: "qux").count).to eq(1)
  end
end
