module Scholrax
  extend ActiveSupport::Autoload

  autoload :Importer
  autoload :Queues

  def self.config(&block)
    @config ||= Scholrax::Configuration.new
    yield @config if block
    @config
  end

end
