# frozen_string_literal: true

require "rake"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:test)
RuboCop::RakeTask.new(:lint)

task default: :test
