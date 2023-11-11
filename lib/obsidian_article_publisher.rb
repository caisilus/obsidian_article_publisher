# frozen_string_literal: true

require_relative "obsidian_article_publisher/link_converter"
require_relative "obsidian_article_publisher/repo_controller"
require "octokit"
require "yaml"

module ObsidianArticlePublisher
  WORKDIR = "workdir"
  SETTINGS = YAML.load_file("settings.yml")

  class ArticlePublisher
    def initialize
      setup_repo
      @link_converter = LinkConverter.new
    end

    private

    def setup_repo
      api = Octokit::Client.new(netrc: true)
      Dir.mkdir(WORKDIR) unless Dir.exist?(WORKDIR)
      @repo_controller = RepoController.new(owner: "caisilus", repo_name: "mmcs_ruby_guides", api:)
    end

    public

    def publish(old_name, new_name)
      converted_article_content = @link_converter.convert_links(article_content(old_name))
      output_article_filename = File.join(@repo_controller.local_dir_path, new_name)
      File.write(output_article_filename, converted_article_content)

      @link_converter.image_names.each do |image_name|
        puts image_name
      end
    end

    private

    def article_content(article_filename)
      article_filename = File.join(SETTINGS["articles_folder"], article_filename)
      File.read(article_filename)
    end
  end
end

publisher = ObsidianArticlePublisher::ArticlePublisher.new
publisher.publish("гайды/Гайд по настройке проекта в Replit и GitHub.md", "Environment/replit.md")
