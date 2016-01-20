# Topher's Rails 4.2.0 app template

This is a starter template I'll use when building new apps.

### What's set up:

- Figaro. `application.yml` will be ignored by Git, so create it yourself.
- Bootstrap from the `bootstrap-sass` gem
- Devise with Bootstrap-friendly Haml templates
- Secret token is dynamically generated each time the server starts up.
- App renders times in terms of US EST
- Mandrill configured for mailings. (Put the API)
- Controllers: Home (home, about), Users (show)
- Vanilla Bootstrap layout with a top navbar with login & logout links,
  standard Flash message support.
- ApplicationHelper #show_errors_for model validation helper
- Simple Rspec setup with starter specs

### To create a new app from it:

- Rewrite this readme
- Push up to new repository

### Heroku prep

- Add gem `rails_12factor` in group `:production`
- `bundle install`
- `rake rails:update:bin`
- set `config.force_ssl = true` in production
- Ensure Glyphicon fonts compile correctly in production:

```
config.assets.precompile += %w( .woff .eot .svg .ttf )
config.assets.compile = true (from false)
```

- `heroku create`
- `git push heroku master`
- `heroku run rake db:migrate`
- `rake figaro:heroku`
- `heroku open` and test!

### Maintaining it

Keep this app up to date by periodically updating gems and config to reflect the habitual tweaks I make when starting a new app. One change here can save me tons of time with each sandbox app I spin up down the road.
