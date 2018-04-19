source 'https://rubygems.org'

gem 'rails', '5.1.6'

gem 'pg'

gem 'puma', '~> 3.11.4'

gem 'dotenv-rails'
gem 'newrelic_rpm'
gem 'settingslogic'

gem 'devise',             '~> 4.4.3'
gem 'omniauth',           '~> 1.6.1'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'simple_form',        '~> 3.5.1'

gem 'autoprefixer-rails', '~> 8.2'
gem 'bourbon',            '~> 5.0.0'
gem 'coffee-rails',       '~> 4.2.1'
gem 'draper',             '~> 3.0.0.pre1'
gem 'haml-rails',         '~> 1.0.0'
gem 'jbuilder',           '~> 2.5'
gem 'jquery-rails'
gem 'modernizr-rails'
gem 'neat', '~> 2.1.0'
gem 'pundit'
gem 'rails_html_helpers'
gem 'redcarpet'
gem 'sass-rails',         '~> 5.0.6'
gem 'sprockets-rails',    '~> 3.2.0'
gem 'turbolinks'
gem 'uglifier', '>= 1.0.3'

gem 'activemodel-serializers-xml'

group :development do
  gem 'foreman'
  gem 'rubocop', '~> 0.55', require: false

  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test, :development do
  gem 'factory_bot_rails', '~> 4.8'
  gem 'rspec-rails',       '~> 3.3'
end

group :test do
  gem 'accept_values_for'
  gem 'capybara', '~> 2.1'
  gem 'json_spec'
  gem 'rails-controller-testing'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-its'
  gem 'simplecov', require: false
end

group :production, :staging do
  gem 'exception_notification', '~> 4.0.1'
  gem 'rack-robotz',            '~> 0.0.3'
end
