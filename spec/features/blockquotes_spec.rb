# frozen_string_literal: true

require "contentfs"

RSpec.describe "defining blockquotes with a type" do
  let(:database) {
    ContentFS::Database.load(path)
  }

  let(:path) {
    File.expand_path("../blockquotes/support/content", __FILE__)
  }

  it "adds a class to typed blockquotes" do
    expect(database.find(:typed).render).to eq_sans_whitespace(
      <<~CONTENT
        <blockquote class="testing">
          <p>
            This is a test.
          </p>
        </blockquote>
      CONTENT
    )
  end

  it "does not add a class to untyped blockquotes" do
    expect(database.find(:untyped).render).to eq_sans_whitespace(
      <<~CONTENT
        <blockquote>
          <p>
            This is a test.
          </p>
        </blockquote>
      CONTENT
    )
  end
end
