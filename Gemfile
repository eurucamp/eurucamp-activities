source 'https://rubygems.org'

ruby "2.0.0"

gem 'rails', '4.0.0.rc1'
gem 'pg'
gem 'unicorn'
gem 'settingslogic'
gem 'newrelic_rpm'

gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.0.1'
# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'
gem 'bourbon'
gem 'neat'
gem 'haml-rails'

group :development do
  gem 'debugger',       '~> 1.5'
  gem 'heroku_san',     '~> 3.0.2'
  gem 'foreman'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
end

group :test do
  gem 'turn',       require: false
  gem 'simplecov',  require: false
end

group :assets do
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'coffee-rails', '~> 4.0.0.beta1'
  gem 'uglifier', '>= 1.0.3'
end

group :production, :staging do
  # git version for rails-4.x compatibility
  gem 'exception_notification', require: 'exception_notifier', git: 'git://github.com/smartinez87/exception_notification.git'
  gem 'rack-robotz', '~> 0.0.3'
end
