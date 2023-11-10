# frozen_string_literal: true

require_relative "../lib/link_converter/link_converter"

RSpec.describe ObsidianArticlePublisher::LinkConverter, "#convert_links" do
  it "converts singular image link from wiki format to markdown format" do
    text = "![[img1.png]]"
    base_path = "images/"
    converted_text = ObsidianArticlePublisher::LinkConverter.convert_links(text, base_path:)
    expect(converted_text).to eq "![images/img1.png](images/img1.png)"
  end

  it "convert links in multiline text" do
    text = "Hello!\nHere is link: ![[img.png]]\nCheck out this one too! ![[img1.png]]"
    base_path = "images/hello_text"
    converted_text = ObsidianArticlePublisher::LinkConverter.convert_links(text, base_path:)
    expect(converted_text).to eq "Hello!\nHere is link: ![images/hello_text/img.png](images/hello_text/img.png)\n" \
                                 "Check out this one too! ![images/hello_text/img1.png](images/hello_text/img1.png)"
  end

  it "uses blank as default base_path" do
    text = "![[img1.png]] is a nice link"
    converted_text = ObsidianArticlePublisher::LinkConverter.convert_links(text)
    expect(converted_text).to eq "![img1.png](img1.png) is a nice link"
  end

  it "doesn't change text containing zero wiki links" do
    text = "Ordinary text"
    converted_text = ObsidianArticlePublisher::LinkConverter.convert_links(text)
    expect(converted_text).to eq text
  end
end
