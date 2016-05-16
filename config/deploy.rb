require "bundler/capistrano"
require "rvm/capistrano"

#require "whenever/capistrano"

load "config/recipes/base"
load "config/recipes/apache"
load "config/recipes/logger"
load "config/recipes/check"
load "config/recipes/rbenv"
#load "config/recipes/nodejs"
load "config/recipes/mysql"
load "config/recipes/system"
load "config/recipes/monit"

set :scm, "git"
set :repository, "git@github.com:veritobc/test01.git"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]
set :rvm_type, :user
set :use_sudo, false

set :application, "masqueplus.es"


desc "RackSpace Envirement"
task :development do
  server "192.168.1.125", :web, :app, :db, primary: true
  set :application, "192.168.1.125"
  set :repository, "git@github.com:veritobc/test01.git"  
  set :user, "deployer"
  set :deploy_to, "/home/#{user}/apps/#{application}"
  set :rails_env, "staging"
  set :branch, "develop"
end


# desc "Production Master"
# task :production do
#   server "162.13.177.116", :web, :app, :db, primary: true
#   set :application, "masqueplus.es"
#   set :repository, "git@github.com:verocastro/MasQPlus-Web.git"
#   set :user, "deployer"
#   set :deploy_to, "/home/#{user}/apps/#{application}"
#   set :rails_env, "production"
#   set :branch, "develop"
# end

namespace :deploy do
  namespace :assets do
   desc "Precompile assets locally and then rsync to deploy server"
    task :precompile, :only => { :primary => true } do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
    end
  end
end

after "deploy", "sym:links"       # make carrierwave uploads sym links
after "deploy", "deploy:cleanup"  # keep only the last 5 releases
after "deploy", "deploy:migrate"
after "deploy", "apache:restart"
after "deploy", "deploy:assets:precompile"

require './config/boot'
#require 'airbrake/capistrano'