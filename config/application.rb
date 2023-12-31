require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PulsecheckerDashboard
  class Application < Rails::Application
    Dir['../lib/app_mode/*.rb'].each { |file| require_relative file }
    require_relative '../lib/app_mode'

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.middleware.use OliveBranch::Middleware

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.eager_load_paths << Rails.root.join('lib')
    # Autoload lib directory
    config.autoload_paths << Rails.root.join('lib')
  end
end
