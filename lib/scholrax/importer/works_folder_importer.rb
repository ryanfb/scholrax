require "pathname"

module Scholrax::Importer
  class WorksFolderImporter

    attr_reader :admin_set_id, :export_top_folder, :metadata_mapping_file

    CONTENTS_FILE = "contents"

    def initialize(export_top_folder:,
                   admin_set_id: AdminSet::DEFAULT_ID,
                   metadata_mapping_file:  MetadataFileReader::DEFAULT_METADATA_MAPPING_FILE)
      @admin_set_id = admin_set_id
      @export_top_folder = export_top_folder
      @metadata_mapping_file = metadata_mapping_file
    end

    def call
      get_child_folders.each do |dir|
        Scholrax::Importer::WorkImporterJob.perform_later(export_path: dir.to_s, 
                                                            admin_set_id: admin_set_id, 
                                                            metadata_mapping_file: metadata_mapping_file)
      end
    end

    def get_child_folders
    	Pathname.new(export_top_folder).children.select do |c| 
        c.directory? && 
          Dir.glob("#{c}/#{CONTENTS_FILE}").present? && 
          Dir.glob("#{c}/*\.xml").present?
      end
    end

  end
end
