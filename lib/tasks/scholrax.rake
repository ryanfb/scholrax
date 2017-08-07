namespace :scholrax do
  namespace :queues do
    desc "Report the status of the pool manager"
    task :status => :environment do
      puts "The pool manager is #{Scholrax::Queues.running? ? 'running' : 'stopped'}."
    end

    desc "Start the queue pool manager and workers"
    task :start => :environment do
      if Scholrax::Queues.start
        puts "Starting pool manager and workers."
      else
        puts "Error attempting to start pool manager and workers (may already be running)."
      end
    end

    desc "Stop the pool manager and workers"
    task :stop => :environment do
      if Scholrax::Queues.stop
        puts "Shutting down workers and pool manager."
      else
        puts "Error attempting to shut down workers and pool manager (may not be running)."
      end
    end

    desc "Restart (stop/start) the pool manager and workers"
    task :restart => :environment do
      if Scholrax::Queues.restart
        puts "Restarting pool manager and workers."
      else
        puts "Error attempting to restart pool manager and workers."
      end
    end

    desc "Reload the pool manager config and restart workers"
    task :reload => :environment do
      if Scholrax::Queues.reload
        puts "Reloading pool manager config and restarting workers."
      else
        puts "Error attempting to reload pool manager config and restart workers."
      end
    end
  end
end
