require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ImessageOnRails
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = "Eastern Time (US & Canada)"
    config.theme = "solarized-dark"

    config.active_record.sqlite3.represent_boolean_as_integer = true

    config.web_console.whitelisted_ips = "192.168.86.139"
  end
end
