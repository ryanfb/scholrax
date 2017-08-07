module Scholrax::Importer
  module Factory
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :ObjectFactory
      autoload :WorkFactory
    end

    def self.for(model_name)
      const_get "#{model_name}Factory"
    end

  end
end
