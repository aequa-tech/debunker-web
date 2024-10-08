require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DebunkerWeb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Read the Docker environment file if it exists
    if ENV['DOCKERIZED'] == 'true' && File.exist?(Rails.root.join('.docker.env'))
      Dotenv.load(Rails.root.join('.docker.env'))
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.i18n.default_locale = :it
    config.i18n.available_locales = %i[it en]

    config.to_prepare do
      Devise::Mailer.layout 'mailer'
    end
  end
end
