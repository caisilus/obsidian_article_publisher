# frozen_string_literal: true

require_relative "../lib/obsidian_article_publisher/link_converter"

RSpec.describe ObsidianArticlePublisher::LinkConverter, "#convert_links" do
  it "converts singular image link from wiki format to markdown format" do
    text = "![[img1.png]]"
    base_path = "images/"
    link_converter = ObsidianArticlePublisher::LinkConverter.new
    converted_text = link_converter.convert_links(text, base_path:)
    expect(converted_text).to eq "\n![images/img1.png](images/img1.png)\n"
  end

  it "convert links in multiline text" do
    text = "Hello!\nHere is link: ![[img.png]]\nCheck out this one too! ![[img1.png]]"
    base_path = "images/hello_text"
    link_converter = ObsidianArticlePublisher::LinkConverter.new
    converted_text = link_converter.convert_links(text, base_path:)
    expect(converted_text).to eq "Hello!\nHere is link: \n![images/hello_text/img.png](images/hello_text/img.png)\n\n" \
                                 "Check out this one too! \n![images/hello_text/img1.png](images/hello_text/img1.png)\n"
  end

  it "uses blank as default base_path" do
    text = "![[img1.png]] is a nice link"
    link_converter = ObsidianArticlePublisher::LinkConverter.new
    converted_text = link_converter.convert_links(text)
    expect(converted_text).to eq "\n![img1.png](img1.png)\n is a nice link"
  end

  it "doesn't change text containing zero wiki links" do
    text = "Ordinary text"
    link_converter = ObsidianArticlePublisher::LinkConverter.new
    converted_text = link_converter.convert_links(text)
    expect(converted_text).to eq text
  end

  it "remembers found image names for later use" do
    text = "Hello!\nHere is link: ![[img.png]]\nCheck out this one too! ![[img1.png]]"
    base_path = "images/hello_text"
    converter = ObsidianArticlePublisher::LinkConverter.new
    converter.convert_links(text, base_path:)

    expect(converter.image_names).to eq ["img.png", "img1.png"]
  end

  it "uses block to get new filename for each image if block is given" do
    text = "Hello!\nHere is link: ![[img.png]]\nCheck it out!"
    base_path = "images/test"
    converter = ObsidianArticlePublisher::LinkConverter.new
    converted_text = converter.convert_links(text, base_path:, &:upcase)

    expect(converted_text).to eq "Hello!\nHere is link: \n![images/test/IMG.PNG](images/test/IMG.PNG)\n\nCheck it out!"
  end
end
