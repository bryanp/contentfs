# frozen_string_literal: true

require "contentfs"

RSpec.describe "loading a database" do
  let(:path) {
    File.expand_path("../loading/support/content", __FILE__)
  }

  it "returns a database" do
    expect(ContentFS::Database.load(path)).to be_instance_of(ContentFS::Database)
  end

  context "location does not exist" do
    it "does not raise" do
      expect {
        ContentFS::Database.load("some/missing/path")
      }.not_to raise_error
    end
  end
end
