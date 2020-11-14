# frozen_string_literal: true

RSpec.describe "defining metadata" do
  let(:database) {
    ContentFS::Database.load(path)
  }

  let(:path) {
    File.expand_path("../metadata/support/content", __FILE__)
  }

  it "defines content metadata via front-matter" do
    expect(database.find(:front_matter).metadata).to eq("foo" => "bar")
  end

  it "defines content metadata via _metadata.yml" do
    expect(database.find(:nested, :file_based).metadata).to eq("foo" => "bar")
  end

  it "defines database metadata via _metadata.yml" do
    expect(database.find(:nested).metadata).to eq("foo" => "bar")
  end

  it "merges metadata defined in front-matter and _metadata.yml" do
    expect(database.find(:nested, :merged).metadata).to eq("foo" => "bar", "bar" => "baz")
  end

  it "gives precedence to metadata defined in front-matter" do
    expect(database.find(:nested, :override).metadata).to eq("foo" => "baz")
  end
end
