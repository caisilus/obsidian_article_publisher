# frozen_string_literal: true

require_relative "obsidian_article_publisher/link_converter"
require_relative "obsidian_article_publisher/repo_controller"
require_relative "obsidian_article_publisher/image_name_generator"
require "octokit"
require "yaml"
require "fileutils"
require "pathname"

module ObsidianArticlePublisher
  WORKDIR = "workdir"
  SETTINGS = YAML.load_file("settings.yml")

  class ArticlePublisher
    def initialize
      setup_repo
      @link_converter = LinkConverter.new
      @image_name_generator = ImageNameGenerator.new
    end

    private

    def setup_repo
      api = Octokit::Client.new(netrc: true)
      Dir.mkdir(WORKDIR) unless Dir.exist?(WORKDIR)
      @repo_controller = RepoController.new(owner: "caisilus", repo_name: "mmcs_ruby_guides", api:)
    end

    public

    def publish(article_old_name, article_repo_path:, images_repo_dir:)
      add_converted_article(article_old_name, article_repo_path:, images_repo_dir:)
      @link_converter.image_names.each do |image_name|
        copy_image(image_name, image_destination_dir: images_repo_dir)
      end
      @repo_controller.add(all: true)
      prepare_editor(@repo_controller.local_dir_path, article_repo_path)
      @repo_controller.commit("Add article #{article_repo_path} with images in #{images_repo_dir}")
    end

    private

    def add_converted_article(article_old_name, article_repo_path:, images_repo_dir:)
      image_links_base_path = get_relative_path(from: File.dirname(article_repo_path), to: images_repo_dir)
      converted_article_content = @link_converter.convert_links(article_content(article_old_name),
                                                                base_path: image_links_base_path) do |img_name|
        @image_name_generator.generate(img_name)
      end

      output_article_filename = File.join(@repo_controller.local_dir_path, article_repo_path)
      File.write(output_article_filename, converted_article_content)
    end

    def get_relative_path(from:, to:)
      from_path = Pathname.new(from)
      to_path = Pathname.new(to)
      to_path.relative_path_from(from_path).to_s
    end

    def article_content(article_filename)
      article_filename = File.join(SETTINGS["articles_dir"], article_filename)
      File.read(article_filename)
    end

    def copy_image(image_name, image_destination_dir:)
      image_destination_dir = File.join(@repo_controller.local_dir_path, image_destination_dir)
      FileUtils.mkdir_p(image_destination_dir) unless Dir.exist?(image_destination_dir)

      image_source = File.join(SETTINGS["images_dir"], image_name)
      image_destination = @image_name_generator.generate(image_name)
      image_destination = File.join(image_destination_dir, image_destination)

      FileUtils.cp(image_source, image_destination)
    end

    def prepare_editor(project_dir, article_path)
      article_full_path = File.join(project_dir, article_path)

      add_message_to_article(article_full_path, message_for_publisher)

      system("code #{project_dir} -n -w #{article_full_path}")
    end

    def message_for_publisher
      dividor = "#{'=' * 60}\n"
      message = dividor
      message += "WHEN YOU CLOSE THIS FILE, PULL REQUEST TO #{@repo_controller.upstream_url} WILL BE SENT.\n" \
                "THESE LINES WON'T BE ADDED TO COMMIT\n"
      "#{message}#{dividor}\n\n"
    end

    def add_message_to_article(article_full_path, message)
      article_content = message + File.read(article_full_path)
      File.write(article_full_path, article_content)
    end
  end
end

publisher = ObsidianArticlePublisher::ArticlePublisher.new
publisher.publish("гайды/Гайд по настройке проекта в Replit и GitHub.md", article_repo_path: "Environment/replit.md",
                                                                          images_repo_dir: "Images/replit")
