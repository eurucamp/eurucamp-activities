source 'https://rubygems.org'

ruby "2.0.0"

gem 'rails', '4.0.0.beta1'
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

group :development do
  gem 'debugger',       '~> 1.5'
  gem 'heroku_san',     '~> 3.0.2'
  gem 'foreman'
end

group :assets do
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'coffee-rails', '~> 4.0.0.beta1'
  gem 'uglifier', '>= 1.0.3'
end

group :production, :staging do
  # gem 'exception_notification', require: 'exception_notifier'
  gem 'rack-robotz', '~> 0.0.3'
end
