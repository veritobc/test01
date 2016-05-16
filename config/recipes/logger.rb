#
# cap [env] log:tail
#
namespace :log do
  desc "tail log files"
  task :tail, roles: :app do
    trap("INT") { puts 'Interupted'; exit 0; }
    run "tail -n 500 -f #{shared_path}/log/#{rails_env}.log" do |channel, stream, data|
      puts  # for an extra line break before the host name
      puts "#{channel[:host]}: #{data}"
      break if stream == :err
    end
  end
end