class MetadataFileReader

  DEFAULT_METADATA_MAPPING_FILE = Rails.root.join('config', 'metadata_mapping.yml')

  attr_reader :metadata_doc, :metadata_mapping_file

  def initialize(metadata_file_path, metadata_mapping_file = DEFAULT_METADATA_MAPPING_FILE)
    @metadata_doc = read_metadata_file(metadata_file_path)
    @metadata_mapping_file = metadata_mapping_file
  end

  def call
    metadata = {}
    nodes = metadata_doc.xpath('//dcvalue')
    nodes.each do |node|
      property_key = metadata_map[node['element'] + '|' + node['qualifier']]
      if property_key
        metadata[property_key] ||= []
        metadata[property_key] << node.text
      end
    end
    metadata
  end

  def read_metadata_file(metadata_file_path)
    File.open(metadata_file_path) { |f| Nokogiri::XML(f) }
  end

  def metadata_map
    YAML.load(File.read(metadata_mapping_file))
  end

end
