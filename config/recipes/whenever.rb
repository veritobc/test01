namespace :whenever do
  desc "Update crontab with whenever"
  task :update_cron do
     #system "bundle exec whenever --update-crontab #{fetch(:application)}_#{fetch(:stage)}"
     run "cd #{release_path} && bundle exec whenever --update-crontab reminder" 
  end
end