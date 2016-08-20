
source 'https://rubygems.org'
ruby '2.2.2'

# Server
gem 'rails'
gem 'figaro'
gem 'mysql2', '~> 0.3.18' # for compatibility with Rails 4.2.4
gem 'rollbar'

# Domain logic
gem 'acts-as-taggable-on'
gem 'aws-sdk', '>= 2.0.34'
gem 'bcrypt-ruby'
gem 'closure_tree' # performant hierarchy tree storage for Posts
gem 'devise'
gem 'factory_girl'
gem 'faker'
gem 'paperclip', git: "https://github.com/thoughtbot/paperclip"
gem 'will_paginate'

# Frontend
gem 'bootstrap-sass'
gem 'bootstrap-will_paginate'
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
end
