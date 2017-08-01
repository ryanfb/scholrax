module Scholrax::Importer::Factory
  class WorkFactory < ObjectFactory

    self.klass = Work
    self.system_identifier_field = :identifier

  end
end
