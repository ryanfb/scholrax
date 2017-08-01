module Scholrax::Importer::Factory
  class ObjectFactory

    class_attribute :klass, :system_identifier_field

    attr_reader :attributes, :files_directory, :object, :files

    def initialize(attributes, files_dir = nil, files = [])
      @files_directory = files_dir
      @files = files
      @attributes = attributes
    end

    def run
      create
      object
    end

    def create_attributes
      transform_attributes
    end

    def transform_attributes
      attributes.slice(*permitted_attributes).merge(file_attributes)
    end

    def create
      attrs = create_attributes
      @object = klass.new
      work_actor.create(attrs)
    end

    def work_actor
      Hyrax::CurationConcern.actor_factory = Hyrax::ActorFactory
      Hyrax::CurationConcern.actor(@object, Ability.new(User.batch_user))
    end

    def file_attributes
      files_directory.present? && files.present? ? { files: file_paths } : {}
    end

    def file_paths
      files.map { |file_name| File.new(File.join(files_directory, file_name)) }
    end

    def permitted_attributes
      klass.properties.keys << :admin_set_id
    end

  end
end
