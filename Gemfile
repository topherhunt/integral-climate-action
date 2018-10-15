
source 'https://rubygems.org'
ruby '2.3.0'

# Server
gem 'rails', '4.2.10'
gem 'figaro'
gem 'pg'
gem 'rollbar'
gem 'unicorn'
gem 'elasticsearch-model'

# Domain logic
gem 'acts-as-taggable-on'
gem 'aws-sdk', '>= 2.0.34'
gem 'bcrypt-ruby'
gem 'closure_tree' # performant hierarchy tree storage for Posts
gem 'devise'
gem 'factory_girl'
gem 'faker'
gem 'omniauth', '1.3.2'
gem 'omniauth-oauth2', '~> 1.3.1' # LinkedIn auth breaks on version 1.4
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-linkedin-oauth2'
gem 'paperclip', git: "https://github.com/thoughtbot/paperclip"
gem 'will_paginate'

# Frontend
gem 'bootstrap-sass'
gem 'bootstrap-will_paginate'
gem 'chosen-rails'
gem 'coffee-rails'
gem 'font-awesome-rails'
gem 'haml-rails'
gem 'jquery-rails'
# gem 'jquery-ui-rails'
gem 'sass-rails'
gem 'uglifier'

group :development do
  gem 'web-console'
end

group :development, :test do
  gem 'minitest-rails'
  gem 'm'
  gem 'pry'
  gem 'binding_of_caller'
  gem 'quiet_assets'
  gem 'bullet'
end

group :test do
  gem 'capybara-webkit'
  gem 'capybara-screenshot', '>= 1.0.13'
  gem 'maxitest'
  gem 'minitest-rails-capybara'
  gem 'mocha'
  gem 'launchy' # for save_and_open_page
end

group :production do
  gem 'rails_12factor'
  gem 'rack-timeout' # for easier debugging of timed-out requests
  gem 'bonsai-elasticsearch-rails'
end
