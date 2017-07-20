class ContentsFileReader 

  attr_reader :contents_file_path
  
  def initialize(contents_file_path)
    @contents_file_path = contents_file_path
  end

  def call
    contents = {}

    File.readlines(contents_file_path).each do |line|
      value, key = line.match( /(.*)\s+bundle:([A-Z]*)/ ).captures
      contents[key] ||= []
      contents[key] << value
    end

    contents
  end

end
