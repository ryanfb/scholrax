class MetadataFileReader

  DEFAULT_METADATA_MAPPING_FILE = Rails.root.join('config', 'metadata_mapping.yml')

  attr_reader :metadata_doc, :metadata_mapping_file
  attr_accessor :metadata

  def initialize(metadata_file_path, metadata_mapping_file = DEFAULT_METADATA_MAPPING_FILE)
    @metadata_doc = read_metadata_file(metadata_file_path)
    @metadata_mapping_file = metadata_mapping_file
    @metadata = {}
  end

  def call
    nodes = metadata_doc.xpath('//dcvalue')
    nodes.each do |node|
      if node.text
        property_key = metadata_map[node['element'] + '|' + node['qualifier']]
        if property_key
          set_metadata_value(property_key, node.text)
        else
          property_key = metadata_map[node['element']]
          set_metadata_value(property_key, node.text) if property_key
        end
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

  def set_metadata_value(key, value)
    metadata[key] ||= []
    metadata[key] << value
  end

end
