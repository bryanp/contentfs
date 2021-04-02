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
      expect(database.find(:simple).to_s).to eq_sans_whitespace("**simple**")
    end

    it "returns rendered content" do
      expect(database.find(:simple).render).to eq_sans_whitespace(
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
      expect(database.find(:code).render).to eq_sans_whitespace(
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

    it "handles empty code blocks" do
      expect(database.find(:code_empty).render).to eq_sans_whitespace(
        <<~CONTENT
          <div class="highlight">
            <pre class="highlight">
              <code>
                hello
              </code>
            </pre>
          </div>
        CONTENT
      )
    end
  end

  describe "unknown format" do
    it "returns plaintext" do
      expect(database.find(:unknown).render).to eq_sans_whitespace(
        <<~CONTENT
          unknown
        CONTENT
      )
    end
  end

  describe "sans extension" do
    it "returns plaintext" do
      expect(database.find(:sans_ext).render).to eq_sans_whitespace(
        <<~CONTENT
          sans ext
        CONTENT
      )
    end
  end

  describe "directory content" do
    it "can be defined" do
      expect(database.find(:nested).render).to eq_sans_whitespace("<p>nested content</p>")
    end
  end

  describe "content with front-matter" do
    it "removes the front-matter" do
      expect(database.find(:front_matter).render).to eq_sans_whitespace("content")
    end
  end

  describe "ignored content" do
    it "ignores content prefixed with an underscore" do
      expect(database.find(:in_progress)).to be(nil)
      expect(database.find(:_in_progress)).to be(nil)
    end

    it "ignores databases prefixed with an underscore" do
      expect(database.find(:ignored_database)).to be(nil)
      expect(database.find(:_ignored_database)).to be(nil)
    end
  end
end
