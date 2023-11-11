# frozen_string_literal: true

require "git"
require "fileutils"

module ObsidianArticlePublisher
  class RepoController
    attr_reader :local_dir_path

    def initialize(owner:, repo_name:, api:)
      @api = api

      @origin = @api.repo "#{owner}/#{repo_name}"
      setup_local(workdir: WORKDIR, repo_name:)
      sync_local_with_upstream
    end

    def setup_local(workdir:, repo_name:)
      puts @origin[:clone_url]
      @local_dir_path = File.join(workdir, repo_name)

      FileUtils.rm_rf(@local_dir_path) if Dir.exist?(@local_dir_path)

      @local = Git.clone(@origin[:clone_url], repo_name, path: workdir)

      upstream = @origin[:parent]
      upstream_url = @api.repo(upstream[:full_name])[:clone_url]
      puts upstream_url

      @local.add_remote("upstream", upstream_url)
    end

    def sync_local_with_upstream
      default_branch = @origin[:default_branch]
      @local.fetch("upstream")
      @local.checkout(default_branch)
      @local.merge("upstream/#{default_branch}")
    end
  end
end
