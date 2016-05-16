namespace :monit do

  desc "Install Monit"
  task :install do
    run "#{sudo} apt-get -y install monit"
  end

  after "deploy:install", "monit:install"

  desc "Setup all Monit configuration"
  task :setup do
    monit_config "monitrc", "/etc/monit/monitrc"
    apache
    syntax
    reload
  end

  task :apache do
    monit_config "apache"
  end

  task :mysql do
    monit_config "mysql"
  end

  task :delayed_job do
    monit_config "delayed_job"
  end

  %w[start stop restart syntax].each do |command|
    desc "Run Monit #{command} script"
    task command do
      run "#{sudo} service monit #{command}"
    end

    desc "Force-reload Monitscript"
    task :reload do
      run "#{sudo} service monit force-reload"
    end
  end
end

def monit_config(name, destination = nil)
  destination ||= "/etc/monit/conf.d/#{name}.conf"
  template "monit/#{name}.erb", "/tmp/monit_#{name}"
  run "#{sudo} mv /tmp/monit_#{name} #{destination}"
  run "#{sudo} chown root #{destination}"
  run "#{sudo} chmod 600 #{destination}"
end