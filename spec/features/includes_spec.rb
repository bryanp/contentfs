# frozen_string_literal: true

require "contentfs"

RSpec.describe "Including content" do
  let(:database) {
    ContentFS::Database.load(path)
  }

  let(:path) {
    File.expand_path("../includes/support/includes", __FILE__)
  }

  it "includes adjacent content" do
    expect(database.find(:adjacent).render).to eq_sans_whitespace("<p><strong>this is a test</strong></p>")
  end

  it "includes content into html blocks" do
    expect(database.find(:html_block).render).to eq_sans_whitespace("<div><p><strong>this is a test</strong></p></div>")
  end

  it "includes content into other includes" do
    expect(database.find(:with_include).render).to eq_sans_whitespace("<p><strong>this is a test</strong></p>")
  end

  it "includes content from child directories relative to self" do
    expect(database.find(:child).render).to eq_sans_whitespace("<p><strong>this is a child partial</strong></p>")
  end

  it "includes content from parent directories relative to self" do
    expect(database.find(:nested, :parent).render).to eq_sans_whitespace("<p><strong>this is a test</strong></p>")
  end

  it "includes content relative to the top-level database" do
    expect(database.find(:nested, :top).render).to eq_sans_whitespace("<p><strong>this is a test</strong></p>")
  end

  it "correctly includes content that is code" do
    expect(database.find(:with_code).render).to eq_sans_whitespace(database.find(:code).render)
  end
end
