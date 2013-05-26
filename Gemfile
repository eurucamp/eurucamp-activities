source 'https://rubygems.org'

ruby "2.0.0"

gem 'rails',              '4.0.0.rc1'
gem 'pg'
gem 'unicorn'
gem 'settingslogic'
gem 'newrelic_rpm'
gem 'devise',             '~> 3.0.0.rc'
gem 'omniauth',           '~> 1.1.4'
gem 'omniauth-github',    '~> 1.1.0'
gem 'omniauth-twitter',   '~> 0.0.16'
gem 'simple_form',        '~> 3.0.0.beta1'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder',           '~> 1.0.1'
gem 'bourbon'
gem 'neat'
gem 'haml-rails'
gem 'rails_html_helpers'
gem 'draper'

group :development do
  gem 'debugger',         '~> 1.5'
  gem 'heroku_san',       '~> 3.0.2'
  gem 'foreman'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test, :development do
  gem "rspec-rails",       '~> 2.0'
  gem 'factory_girl_rails','~> 4.2'
end

group :test do
  gem 'simplecov',        require: false
  gem 'capybara',         '~> 2.1'
  gem 'capybara-webkit',  '~> 0.14'
  gem 'accept_values_for'
  gem 'json_spec'
end

group :assets do
  gem 'sass-rails',       '~> 4.0.0.beta1'
  gem 'coffee-rails',     '~> 4.0.0.beta1'
  gem 'uglifier',         '>= 1.0.3'
end

group :production, :staging do
  gem 'exception_notification', require: 'exception_notifier', git: 'git://github.com/smartinez87/exception_notification.git'
  gem 'rack-robotz',            '~> 0.0.3'
end
