module Scholrax::Importer
  class HandleFileReader

    attr_reader :handle_file_path

    def initialize(handle_file_path)
      @handle_file_path = handle_file_path
    end

    def handle_id
      File.readlines(handle_file_path).first.chomp if File.file?(handle_file_path)
    end

  end
end