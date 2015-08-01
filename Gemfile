source 'https://rubygems.org'

gem 'rails',              '4.0.8'
gem 'pg'
gem 'thin'
gem 'settingslogic'
gem 'newrelic_rpm'
gem 'devise',             '~> 3.0.0.rc'
gem 'omniauth',           '~> 1.1.4'
gem 'omniauth-github',    '~> 1.1.0'
gem 'omniauth-twitter',   '~> 0.0.16'
gem 'simple_form',        '~> 3.0.1'
gem 'dotenv-rails'

gem 'modernizr-rails'
gem 'sprockets-rails',    '~> 2.1.3'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder',           '~> 1.0.1'
gem 'bourbon'
gem 'neat'
gem 'haml-rails'
gem 'rails_html_helpers'
gem 'draper'
gem 'cancan'
gem 'redcarpet'
gem 'sass-rails',       '~> 4.0.3'
gem 'coffee-rails',     '~> 4.0.0'
gem 'uglifier',         '>= 1.0.3'

group :development do
  gem 'foreman'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test, :development do
  gem 'rspec-rails',       '~> 3.3'
  gem 'factory_girl_rails','~> 4.2'
end

group :test do
  gem 'rspec-its'
  gem 'rspec-activemodel-mocks'
  gem 'simplecov',        require: false
  gem 'capybara',         '~> 2.1'
  gem 'accept_values_for'
  gem 'json_spec'
end

group :production, :staging do
  gem 'exception_notification', '~> 4.0.1'
  gem 'rack-robotz',            '~> 0.0.3'
  gem 'shelly-dependencies'
end
