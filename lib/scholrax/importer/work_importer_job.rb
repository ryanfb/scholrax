module Scholrax::Importer

  class WorkImporterJob < ActiveJob::Base

	  queue_as :importer

	  def perform(args)
	    WorkImporter.new(args).call
	  end

	end
end