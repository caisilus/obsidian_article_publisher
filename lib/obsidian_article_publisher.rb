# frozen_string_literal: true

require_relative "obsidian_article_publisher/link_converter"

module ObsidianArticlePublisher
  def publish
    puts "publish..."
  end

  module_function :publish
end
