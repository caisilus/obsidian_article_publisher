# frozen_string_literal: true

module ObsidianArticlePublisher
  class LinkConverter
    attr_reader :image_names

    def convert_links(text, base_path: nil)
      @image_names = []

      wiki_link_pattern = /!\[\[([^\]]*)\]\]/

      text.gsub(wiki_link_pattern) do |_match|
        link = ::Regexp.last_match(1)

        @image_names << link

        markdown_image_link(link, base_path:)
      end
    end

    private

    def markdown_image_link(link, base_path:)
      link = File.join(base_path, link) unless base_path.nil?

      "![#{link}](#{link})"
    end
  end
end
