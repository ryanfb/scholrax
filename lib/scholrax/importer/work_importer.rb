module Scholrax::Importer
  class WorkImporter

    attr_reader :admin_set_id, :export_path, :metadata_mapping_file

    def initialize(export_path:,
                   admin_set_id: AdminSet::DEFAULT_ID,
                   metadata_mapping_file:  MetadataFileReader::DEFAULT_METADATA_MAPPING_FILE)
      @admin_set_id = admin_set_id
      @export_path = export_path
      @metadata_mapping_file = metadata_mapping_file
    end

    def call
      attrs = metadata_attributes
      attrs.merge!(admin_set_id: admin_set_id)
      Scholrax::Importer::Factory.for(Work).new(attrs, export_path, contents_files['ORIGINAL']).run
    end

    def metadata_attributes
      md_reader = MetadataFileReader.new(File.join(export_path, 'dublin_core.xml'), metadata_mapping_file)
      md_reader.call
    end

    def contents_files
      contents_file_reader = ContentsFileReader.new(File.join(export_path, 'contents'))
      contents_file_reader.call
    end

  end
end
