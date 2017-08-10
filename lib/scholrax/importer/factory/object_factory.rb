module Scholrax::Importer::Factory
  class ObjectFactory

    class_attribute :klass, :system_identifier_field

    attr_reader :attributes, :files_directory, :object, :files

    def initialize(attributes, files_dir = nil, files = [])
      @files_directory = files_dir
      @files = files
      @attributes = attributes.symbolize_keys
    end

    def run
      create
      object
    end

    def create_attributes
      transform_attributes
    end

    def transform_attributes
      attributes.slice(*permitted_attributes).merge(embargo_release_date_attribute).merge(file_attributes)
    end

    def embargo_release_date_attribute
      attributes[:embargo_release_date].present? ? { embargo_release_date: attributes[:embargo_release_date].first }
                                                 : {}
    end

    def create
      attrs = create_attributes
      @object = klass.new
      env = environment(attrs)
      work_actor.create(env)
    end

    def environment(attrs)
      Hyrax::Actors::Environment.new(object, Ability.new(User.batch_user), attrs)
    end

    def work_actor
      Hyrax::CurationConcern.actor
    end

    def file_attributes
      files_directory.present? && files.present? ? { uploaded_files: uploaded_files } : {}
    end

    def file_paths
      files.map { |file_name| File.join(files_directory, file_name) }
    end

    def uploaded_files
      files.map do |file_name|
        f = File.open(File.join(files_directory, file_name))
        upf = Hyrax::UploadedFile.create(file: f, user: User.batch_user)
        f.close
        upf.id
      end
    end

    def permitted_attributes
      klass.properties.keys.map(&:to_sym) + [ :admin_set_id, :embargo_release_date, :visibility,
                                              :visibility_after_embargo, :visibility_during_embargo ]
    end

  end
end
