# frozen_string_literal: true

require "contentfs"

RSpec.describe "navigating through a content database" do
  let(:database) {
    ContentFS::Database.load(path)
  }

  let(:path) {
    File.expand_path("../navigation/support/content", __FILE__)
  }

  context "via methods" do
    it "exposes content for top-level files" do
      expect(database.top.to_s).to eq_sans_whitespace("top")
    end

    it "exposes content for nested files" do
      expect(database.nested.foo.to_s).to eq_sans_whitespace("nested foo")
    end

    it "exposes content for deeply nested files" do
      expect(database.deeply.nested.foo.to_s).to eq_sans_whitespace("deeply nested foo")
    end

    it "exposes content for deeply nested files using arguments" do
      expect(database.deeply(:nested, :foo).to_s).to eq_sans_whitespace("deeply nested foo")
    end
  end
end
