# frozen_string_literal: true

module ObsidianArticlePublisher
  module LinkConverter
    def convert_links(text, base_path: nil)
      wiki_link_pattern = /!\[\[([^\]]*)\]\]/

      text.gsub(wiki_link_pattern) do |_match|
        link = ::Regexp.last_match(1)

        link = File.join(base_path, link) unless base_path.nil?

        "![#{link}](#{link})"
      end
    end

    module_function :convert_links
  end
end
