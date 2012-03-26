source :rubygems

gem 'rails', '3.2.2'
gem 'pg'

gem 'devise',                 '2.0.4'
gem 'decent_exposure',        '1.0.2'
gem 'haml',                   '3.1.4'
gem 'omniauth-twitter',       '0.0.8'
gem 'nestful',                '0.0.8'
gem 'newrelic_rpm',           '3.3.2.1', :group => :production
gem 'nokogiri',               '1.5.2'
gem 'rinku',                  '1.5.1', :require => 'rails_rinku'
gem 'statistics2',            '0.54'

group :assets do
  gem 'sass-rails',              '~> 3.2.3'
  gem 'coffee-rails',            '~> 3.2.1'
  gem 'jquery-rails',            '2.0.1'
  gem 'uglifier',                '>= 1.0.3'
  gem 'twitter-bootstrap-rails', '2.0.3'
  gem 'chosen-rails',            '0.9.8'
  gem 'compass-rails',           '1.0.1'
end

group :assets, :production do
  gem 'asset_sync',
    :git => 'git://github.com/rumblelabs/asset_sync.git',
    :ref => '1edb3622d7'
end

group :development, :test do
  gem 'rspec-rails', '2.8.1'
end
