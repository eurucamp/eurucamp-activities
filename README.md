# eurucamp Activities [![License](http://img.shields.io/:license-AGPL-0030c8.svg)](COPYRIGHT) [![Build Status](https://travis-ci.org/isleofruby/isleofruby-activities.png?branch=master)](https://travis-ci.org/isleofruby/isleofruby-activities)

The Activities app is a small application to allow attendees to organize and plan small event in and around a conference. Users create events or sign up to created ones. Signup works through GitHub or Twitter.

The app is mobile friendly and easy to run on a free Heroku account.

## Donationware

The app was created by members on the Ruby Berlin e.V. on their free time as a community effort initially for the eurucamp conference. Ruby Berlin is the body behind RailsGirls Berlin and Hamburg, eurucamp and JRubyConf.eu.

If you end up using the app, please get in [contact](mailto:info@isleofruby.org) so that we know. Also, spread the word about our [projects](http://rubyberlin.org). Also, consider [donating](https://www.betterplace.org/en/organisations/ruby-berlin/), especially, if you run a commercial conference. We are a registered non-profit, donations are tax deducible. Betterplace handles all paperwork - if in doubt, send us a mail.

If you cannot or don't want to donate - use it, it's free.

## Logo

Don't use the Isle of Ruby logo for your instance to avoid confusion.

## Examples

Screenshot: ![The activities app](screenshot.png)

## Running the app on Heroku

To deploy the app, you need the following:

* Clone this repository: `https://github.com/isleofruby/isleofruby-activities/`

* An account and a created application at Heroku.
* A registered Twitter application. Go [here](https://apps.twitter.com/).
* A registered GitHub application. Go [here](https://github.com/settings/applications).

Deploying is as easy as:

* Add their keys to your Heroku app as described [here](https://devcenter.heroku.com/articles/config-vars) using the env variables described below.
* Push the repository to Heroku: `git push  git@heroku.com:<name-of-your-app>.git`

### **ENV** variables used:

* `GITHUB_KEY`: Your GitHub application key.
* `GITHUB_SECRET`: Your GitHub application secret.
* `TWITTER_KEY`: Your Twitter application key.
* `TWITTER_SECRET`: Your Twitter application secret.

## Development

An installed postgresql instance and a compiler is needed.

### Basic setup

* `echo 'activities.dev localhost' >> /etc/hosts`
* `cp .env.sample .env`
* `cp config/database.yml.sample config/database.yml`
* update config files: `config/application.yml`, `.env` (see ENV variables listed above)
* `bundle exec rake db:create`
* `bundle exec rake db:migrate`
* `bundle exec foreman start`
* `tail -f log/development.log`
* `open http://activities.dev:3000`
* run the specs: `bundle exec rake`

### Customization

Customization is currently work in process, so the way to go is to fork the application.

* Fork it
* edit `config/application.yml`
* edit `app/assets/stylesheets/_settings.sass`

## Authors

This app was created by:

* [Florian Plank](https://twitter.com/polarblau)
* [Piotr Gęga](https://twitter.com/piotrgega)

## License

GNU-AGPL-3.0, see COPYRIGHT for details.
