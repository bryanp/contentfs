# frozen_string_literal: true

RSpec.describe "defining metadata" do
  let(:database) {
    ContentFS::Database.load(path)
  }

  let(:path) {
    File.expand_path("../metadata/support/content", __FILE__)
  }

  it "defines metadata via front-matter" do
    expect(database.front_matter.metadata).to eq("foo" => "bar")
  end

  it "defines metadata via _metadata.yml" do
    expect(database.nested.file_based.metadata).to eq("foo" => "bar")
  end

  it "merges metadata defined in front-matter and _metadata.yml" do
    expect(database.nested.merged.metadata).to eq("foo" => "bar", "bar" => "baz")
  end

  it "gives precedence to metadata defined in front-matter" do
    expect(database.nested.override.metadata).to eq("foo" => "baz")
  end

  it "does not expose the metadata file as content" do
    expect {
      database.nested.metadata
    }.to raise_error(NoMethodError)
  end
end
