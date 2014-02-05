# eurucamp Activities [2013+]

## Development

### Basic setup

* `echo 'activities.dev localhost' > /etc/hosts`
* `cp .env.sample .env`
* `cp config/database.yml.sample config/database.yml`
* update config files: `config/application.yml`, `.env` (see ENV variables listed below)
* run migration scripts
* `bundle exec foreman start`
* `tail -f log/development.log`
* `open http://activities.dev:3000`

### Customization

*(work in progress)*

* Fork it
* edit `config/application.yml`
* edit `app/assets/stylesheets/_settings.sass`

## Deployment

### How to deploy app?

* `bundle exec rake staging deploy`
* `bundle exec rake production deploy`

### **ENV** variables:

* `GITHUB_KEY`
* `GITHUB_SECRET`
* `TWITTER_KEY`
* `TWITTER_SECRET`
