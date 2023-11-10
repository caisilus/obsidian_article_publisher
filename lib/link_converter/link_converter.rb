module ObsidianArticlePublisher
  module LinkConverter
    def convert_link(link, base_path: nil)
      match = /\!\[\[([^\]]*)\]\]/.match(link)
      raise ArgumentError.new("Incorrect wiki link: #{link}") if match.nil?

      image_name = match[1]

      image_name = File.join(base_path, image_name) unless base_path.nil?

      "![#{image_name}](#{image_name})"
    end

    module_function :convert_link
  end
end
