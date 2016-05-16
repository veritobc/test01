namespace :info do
  desc "Displays memory usage"
  task :memory do
    mem = capture("free -m | grep Mem").squeeze(" ").split(" ")[1..-1]
    total, used, free, shared, buffers, cached = mem

    puts "\nMemory in (MBs)"
    puts "----------------------------"
    puts "Total: #{total}"
    puts "Used: #{used}"
    puts "Free: #{free}"
    puts "Shared: #{shared}"
    puts "Buffers: #{buffers}"
    puts "Cached: #{cached}"
    puts "----------------------------\n\n"
  end

  desc "Remove Assets"
  task :rm_assets do
    run "rm -rf #{current_path}/public/assets"
  end
end