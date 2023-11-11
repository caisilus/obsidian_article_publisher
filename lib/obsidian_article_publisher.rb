# frozen_string_literal: true

require_relative "obsidian_article_publisher/link_converter"
require "octokit"
require_relative "obsidian_article_publisher/repo_controller"

module ObsidianArticlePublisher
  WORKDIR = "workdir"

  def publish
    api = Octokit::Client.new(netrc: true)
    Dir.mkdir(WORKDIR) unless Dir.exist?(WORKDIR)
    @repo_controller = RepoController.new(owner: "caisilus", repo_name: "mmcs_ruby_guides", api:)
  end

  module_function :publish
end

ObsidianArticlePublisher.publish
