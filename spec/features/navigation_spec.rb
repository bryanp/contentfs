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
    it "exposes top-level content" do
      expect(database.top.to_s).to eq_sans_whitespace("top")
    end

    it "exposes nested content" do
      expect(database.sub.foo.to_s).to eq_sans_whitespace("nested foo")
    end

    it "exposes deeply nested content" do
      expect(database.deeply.sub.foo.to_s).to eq_sans_whitespace("deeply nested foo")
    end

    it "exposes deeply nested content using arguments" do
      expect(database.deeply(:sub, :foo).to_s).to eq_sans_whitespace("deeply nested foo")
    end

    it "raises when nothing is not defined" do
      expect {
        database.missing
      }.to raise_error(NoMethodError)
    end
  end

  context "via find" do
    it "finds top-level content" do
      expect(database.find(:top).to_s).to eq_sans_whitespace("top")
    end

    it "finds nested content" do
      expect(database.find(:sub, :foo).to_s).to eq_sans_whitespace("nested foo")
    end

    it "finds deeply nested content" do
      expect(database.find(:deeply, :sub, :foo).to_s).to eq_sans_whitespace("deeply nested foo")
    end

    it "returns nil when nothing is not defined" do
      expect(database.find(:missing)).to be(nil)
    end
  end
end
