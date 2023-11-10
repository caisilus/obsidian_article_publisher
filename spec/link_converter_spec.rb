require_relative "../lib/link_converter/link_converter.rb"

RSpec.describe ObsidianArticlePublisher::LinkConverter, "#convert_link" do
  it "converts image link from wiki format to markdown format" do
    link = "![[img1.png]]"
    base_path = "images/"
    converted_link = ObsidianArticlePublisher::LinkConverter.convert_link(link, base_path: base_path)
    expect(converted_link).to eq "![images/img1.png](images/img1.png)"
  end

  it "uses blank as default base_path" do
    link = "![[img1.png]]"
    converted_link = ObsidianArticlePublisher::LinkConverter.convert_link(link)
    expect(converted_link).to eq "![img1.png](img1.png)"
  end

  it "raises ArgumentError when provided string is not correct wiki link" do
    link = "![incorrect.png]"

    expect do
      converted_link = ObsidianArticlePublisher::LinkConverter.convert_link(link)
    end.to raise_error(ArgumentError, "Incorrect wiki link: #{link}")
  end
end
