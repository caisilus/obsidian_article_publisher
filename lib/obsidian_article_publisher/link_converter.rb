# frozen_string_literal: true

module ObsidianArticlePublisher
  class LinkConverter
    attr_reader :image_names

    def convert_links(text, base_path: nil, &block)
      @image_names = []

      wiki_link_pattern = /!\[\[([^\]]*)\]\]/

      text.gsub(wiki_link_pattern) do |_match|
        link = ::Regexp.last_match(1)

        @image_names << link

        markdown_image_link(link, base_path:, &block)
      end
    end

    private

    def markdown_image_link(link, base_path:)
      link = yield(link) if block_given?
      link = File.join(base_path, link) unless base_path.nil?

      "\n![#{link}](#{link})\n"
    end
  end
end
