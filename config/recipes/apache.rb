namespace :apache do
  desc "Installs apache server and remove the default site"
  task :install, roles: :web do
    run "#{sudo} apt-get -y install apache2 && a2enmod rewrite"
    run "#{sudo} a2dissite default"
    restart
  end

  desc "Setup application to run on a Passenger VHost"
  task :setup, roles: :web do
    template "apache_passenger.erb", "/tmp/#{application}_apache.conf"
    run "#{sudo} mv /tmp/#{application}_apache.conf /etc/apache2/sites-enabled/#{application}"
    run "#{sudo} rm -f /etc/apache2/sites-enabled/default"
    restart
  end

  %w[start stop restart graceful].each do |command|
    desc "Apache2 #{command}"
    task command, roles: :web do
      run "#{sudo} /etc/init.d/apache2 #{command}"
    end
  end
end
