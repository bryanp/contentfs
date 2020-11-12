# frozen_string_literal: true

require "contentfs"

RSpec.describe "accessing content" do
  let(:database) {
    ContentFS::Database.load(path)
  }

  let(:path) {
    File.expand_path("../content/support/content", __FILE__)
  }

  describe "markdown" do
    it "defines simple markdown content" do
      expect(database.simple.to_s).to eq_sans_whitespace("**simple**")
    end

    it "returns rendered content" do
      expect(database.simple.render).to eq_sans_whitespace(
        <<~CONTENT
          <p>
            <strong>simple</strong>
          </p>
        CONTENT
      )
    end
  end

  describe "markdown with code" do
    it "handles syntax highlighting" do
      expect(database.code.render).to eq_sans_whitespace(
        <<~CONTENT
          <div class="highlight">
            <pre class="highlight ruby">
              <code>
                <span class="nb">puts</span> <span class="s2">"hello"</span>
              </code>
            </pre>
          </div>
        CONTENT
      )
    end
  end

  describe "unknown format" do
    it "returns plaintext" do
      expect(database.unknown.render).to eq_sans_whitespace(
        <<~CONTENT
          unknown
        CONTENT
      )
    end
  end

  describe "sans extension" do
    it "returns plaintext" do
      expect(database.sans_ext.render).to eq_sans_whitespace(
        <<~CONTENT
          sans ext
        CONTENT
      )
    end
  end

  describe "missing content" do
    it "raises" do
      expect {
        database.missing
      }.to raise_error(NoMethodError)
    end
  end

  describe "directory content" do
    it "can be defined" do
      expect(database.nested.render).to eq_sans_whitespace("<p>nested content</p>")
    end
  end
end
