# Eurucamp-activities-2013

## Development

### Basic setup

* `cp .env.sample .env`
* `cp config/database.yml.sample config/database.yml`
* update config files: `config/application.yml`, `.env` (see ENV variables listed below)
* run migration scripts
* `bundle exec foreman start`
* `tail -f log/development.log`

## Deployment

### How to deploy app?

* `bundle exec rake staging deploy`
* `bundle exec rake production deploy`

### **ENV** variables:

* `DISABLE_ROBOTS` - set to `true` if you want to block robots from tracking content (via `robots.txt`)
* `GITHUB_KEY`
* `GITHUB_SECRET`
* `TWITTER_KEY`
* `TWITTER_SECRET`



