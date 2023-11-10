# frozen_string_literal: true

require_relative "link_converter/link_converter"

module ObsidianArticlePublisher
  def publish
    puts "publish..."
  end

  module_function :publish
end
