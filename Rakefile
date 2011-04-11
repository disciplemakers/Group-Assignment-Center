# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Gac::Application.load_tasks

RSpec::Core::RakeTask.new(:rcov) do |spec|
  #spec.pattern = 'spec/**/*_spec.rb'
  spec.pattern = 'spec/[^v]*/*_spec.rb'
  spec.rcov = true
  spec.rcov_opts = ['--rails', '--threshold', '100', '--exclude', 'views,\/usr\/lib\/ruby\/*,\/var\/lib\/gems\/*,spec\/*,\/var\/local\/devel,app\/views\/*']
end