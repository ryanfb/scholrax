module Scholrax::Importer
  class WorkImporter

    attr_reader :admin_set_id, :export_path, :metadata_mapping_file

    HANDLE_IDENTIFIER_PREFIX = "http://hdl.handle.net/"

    def initialize(export_path:,
                   admin_set_id: AdminSet::DEFAULT_ID,
                   metadata_mapping_file:  MetadataFileReader::DEFAULT_METADATA_MAPPING_FILE)
      @admin_set_id = admin_set_id
      @export_path = export_path
      @metadata_mapping_file = metadata_mapping_file
    end

    def call
      unless work_exists?
        attrs = metadata_attributes
        attrs.merge!({ admin_set_id: admin_set_id, visibility: visibility })
        attrs.merge!(placeholder_attributes)
        attrs.merge!(embargo_attributes) if embargoed?
        obj = Scholrax::Importer::Factory.for(Work).new(attrs, export_path, contents_files['ORIGINAL']).run
        raise Hyrax::HyraxError, invalid_work_error_message(obj) unless obj.valid?
        obj
      end
    end

    def work_exists?
      if work_handle
        handle_identifier = work_handle.prepend(HANDLE_IDENTIFIER_PREFIX)
        Work.exists?(identifier: handle_identifier)
      else
        false
      end
    end

    def work_handle
      handle_file_reader = HandleFileReader.new(File.join(export_path, 'handle'))
      handle_file_reader.handle_id
    end

    def metadata_attributes
      @metadata_attributes ||= read_metadata_attributes
    end

    def metadata_files
      [ File.join(export_path, 'dublin_core.xml') ] + Dir.glob(File.join(export_path, 'metadata_*.xml'))
    end

    def read_metadata_attributes
      attrs = {}
      metadata_files.each do |metadata_file|
        md_reader = MetadataFileReader.new(metadata_file, metadata_mapping_file)
        attrs.merge!(md_reader.call)
      end
      attrs
    end

    def contents_files
      contents_file_reader = ContentsFileReader.new(File.join(export_path, 'contents'))
      contents_file_reader.call
    end

    def placeholder_attributes
      { keyword: [ Scholrax.config.importer_keyword ],
        rights_statement: [ Scholrax.config.importer_rights_statement ] }
    end

    def embargoed?
      metadata_attributes.keys.include?('embargo_release_date') &&
          future_embargo_release_date?(metadata_attributes['embargo_release_date'].first)
    end

    def visibility
      embargoed? ?
          Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_EMBARGO :
          Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end

    def embargo_attributes
      { visibility_during_embargo: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE,
        visibility_after_embargo: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
    end

    def future_embargo_release_date?(date_string)
      date = parse_embargo_date(date_string)
      date.present? && date.future? ? true : false
    end

    def parse_embargo_date(date_string)
      # Logic cribbed from Hyrax::Actors::InterpretVisibilityActor#parse_date
      datetime = Time.zone.parse(date_string) if date_string.present?
      return datetime.to_date unless datetime.nil?
      nil
    end

    def invalid_work_error_message(object)
      I18n.t('scholrax.importer.errors.invalid_work', source_path: export_path, errors: object.errors.full_messages)
    end
  end
end
