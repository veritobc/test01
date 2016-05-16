namespace :mysql do
  desc "Checks database.yml symlink"
  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"
  end
  after "deploy:finalize_update", "mysql:symlink_config"
end