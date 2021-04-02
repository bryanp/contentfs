# frozen_string_literal: true

require "contentfs"

RSpec.describe "accessing content" do
  let(:database) {
    ContentFS::Database.load(path) do |content|
      content.reverse
    end
  }

  let(:path) {
    File.expand_path("../content/support/content", __FILE__)
  }

  it "allows content to be preprocessed" do
    expect(database.find(:simple).to_s).to eq_sans_whitespace("**elpmis**")
  end
end
