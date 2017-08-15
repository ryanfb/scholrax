namespace :scholrax do

  namespace :dspace_importer do
    desc "Scan folder of export folders and queue up as work importer jobs."
    puts "Importer parms: EXPORT_FOLDER, ADMIN_SET, optional: METADATA_MAPPING_FILE"
 
    task :call => :environment do
      raise "Must specify folder path to exported folders. Ex.: EXPORT_FOLDER=/path/to/folders" unless ENV["EXPORT_FOLDER"]
      raise "Must specify an admin set id. Ex.: ADMIN_SET=adminset_a" unless ENV["ADMIN_SET"]

      processor_args =  { export_top_folder: ENV["EXPORT_FOLDER"] }
      processor_args[:admin_set_id] = ENV["ADMIN_SET"] if ENV["ADMIN_SET"]
      processor_args[:metadata_mapping_file] = ENV['METADATA_MAPPING_FILE'] if ENV['METADATA_MAPPING_FILE']
      
      processor = Scholrax::Importer::WorksFolderImporter.new(processor_args)
      processor.call
    end
  end
  
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
