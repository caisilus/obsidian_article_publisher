# frozen_string_literal: true

module ObsidianArticlePublisher
  class ImageNameGenerator
    def initialize
      @index = 0
      @names_hash = {}
    end

    def generate(original_name)
      return @names_hash[original_name] if @names_hash.include?(original_name)

      @index += 1
      extension = original_name.split(".")[-1]
      generated_name = "#{@index}.#{extension}"
      @names_hash[original_name] = generated_name
    end
  end
end
