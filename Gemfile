
source 'https://rubygems.org'
ruby '2.5.3'

# Server
gem 'rails', '~> 5.2.2'
gem 'figaro'
gem 'pg', '~> 0.18' # Rails needs pre-1.0, else you get vague conflict errors
gem 'rollbar'
gem 'unicorn'
gem 'elasticsearch'
gem 'lograge'

# Domain logic
gem 'acts-as-taggable-on'
gem 'aws-sdk'
gem 'factory_bot'
gem 'faker'
gem 'omniauth'
gem 'omniauth-auth0'
gem 'paperclip', git: "https://github.com/thoughtbot/paperclip" # Deprecated (see readme)

# Frontend
gem 'bootstrap-sass'
gem 'bootstrap-will_paginate'
gem 'chosen-rails'
gem 'coffee-rails'
gem 'font-awesome-rails'
gem 'haml-rails'
gem 'jquery-rails'
gem 'sass-rails' # NOTE: `sass` is sunsetting, but `sass-rails` still requires it
gem 'uglifier'
gem 'will_paginate'

group :development do
  gem 'web-console'
end

group :development, :test do
  gem 'minitest-rails'
  gem 'm'
  gem 'pry'
  gem 'binding_of_caller'
  gem 'bullet'
end

group :test do
  gem 'poltergeist'
  gem 'maxitest'
  gem 'minitest-rails-capybara'
  gem 'mocha'
  gem 'launchy' # for save_and_open_page
end

group :production do
  gem 'rails_12factor'
  gem 'rack-timeout' # for easier debugging of timed-out requests
end
