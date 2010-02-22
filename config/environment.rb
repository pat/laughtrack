# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Application Gems
  config.gem 'haml',            :version => '>= 2.2.16'
  config.gem 'nokogiri',        :version => '>= 1.4.1'
  config.gem 'clearance',       :version => '0.8.3'
  config.gem 'thinking-sphinx', :version => '1.3.14', :lib => 'thinking_sphinx'
  config.gem 'formtastic',      :version => '0.9.7'
  config.gem 'throne',          :version => '0.0.6'
  config.gem 'pedantic',        :version => '>= 0.1.0'
  config.gem 'will_paginate',   :version => '2.3.12'
  
  # Testing Gems
  config.gem 'rspec',       :lib => false, :version => '>= 1.2.9'
  config.gem 'rspec-rails', :lib => false, :version => '>= 1.2.9'
  config.gem 'fakeweb',     :lib => false, :version => '>= 1.2.7'
  config.gem 'machinist',
    :lib      => false,
    :source   => 'http://gems.github.com',
    :version  => '>= 1.0.6'
  config.gem 'fakeweb-matcher',
    :lib      => false,
    :source   => 'http://gems.github.com',
    :version  => '>= 1.1.0'
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

# For Thoughtbot's Clearance:
DO_NOT_REPLY = 'donotreply@freelancing-gods.com'
