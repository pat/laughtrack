ENV["RAILS_ENV"] ||= 'test'

unless defined?(RAILS_ROOT)
  require File.dirname(__FILE__) + "/../config/environment"
end

require 'spec/autorun'
require 'spec/rails'
require 'machinist/active_record'
require 'fakeweb'
require 'fakeweb_matcher'

require 'spec/blueprints'
require 'spec/shared/examples'
require 'spec/shared/methods'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
end

FakeWeb.allow_net_connect = false
