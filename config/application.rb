require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Scholrax
  class Application < Rails::Application


      # The compile method (default in tinymce-rails 4.5.2) doesn't work when also
      # using tinymce-rails-imageupload, so revert to the :copy method
      # https://github.com/spohlenz/tinymce-rails/issues/183
      config.tinymce.install = :copy
    config.generators do |g|
      g.test_framework :rspec, :spec => true
    end


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.active_job.queue_adapter = :inline

    # Load environment variables from file
    # http://railsapps.github.io/rails-environment-variables.html
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      if File.exists?(env_file)
        YAML.load_file(env_file).each { |key, value| ENV[key.to_s] = value.to_s }
      end
    end

  end
end
