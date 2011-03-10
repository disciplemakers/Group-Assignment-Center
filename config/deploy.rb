set :application, "group_assignment_center"
default_run_options[:pty] = true
set :repository,  "git@github.com:disciplemakers/Group-Assignment-Center.git"

set :scm, :git
set :user, "capistrano"
set :deploy_to, "/var/lib/capistrano/apps"
require "bundler/capistrano"
set :use_sudo, false
ssh_options[:forward_agent] = true
set :branch, "devel"
set :deploy_via, :remote_cache
set :domain, "rails-dmz"
set :db_domain, "mysql-dmz"

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, domain                         # Your HTTP server, Apache/etc
role :app, domain                         # This may be the same as your `Web` server
role :db,  domain, :primary => true    # This is where Rails migrations will run  

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  
  task :copy_database_configuration do
    production_db_config = "/var/lib/capistrano/gac-production.database.yml"
    run "cp #{production_db_config} #{release_path}/config/database.yml"
  end
  
  after "deploy:update_code" , "deploy:copy_database_configuration"

#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
end