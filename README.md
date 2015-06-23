# rubyweek [![License](http://img.shields.io/:license-AGPL-0030c8.svg)](COPYRIGHT) [![Build Status](https://travis-ci.org/eurucamp/eurucamp-activities.png?branch=master)](https://travis-ci.org/eurucamp/eurucamp-activities)

The rubyweek app is a small application to allow attendees to organize and plan small event in and around a conference. Users create events or sign up to created ones. Signup works through Github or Twitter.

The app is mobile friendly and easy to run on a free Heroku account.

## Donationware

The app was created by members on the Ruby Berlin e.V. on their free time as a community effort for the eurucamp conference. Ruby Berlin is the body behind RailsGirls Berlin and Hamburg, eurucamp and JRubyConf.eu.

If you end up using the app, please get in [contact](mailto:info@eurucamp.org) so that we know. Also, spread the word about our [projects](http://rubyberlin.org). Also, consider [donating](https://www.betterplace.org/en/organisations/ruby-berlin/), especially, if you run a commercial conference. We are a registered non-profit, donations are tax deducible. Betterplace handles all paperwork - if in doubt, send us a mail.

If you cannot or don't want to donate - use it, it's free.

## Logo

Don't use the eurucamp logo for your instance to avoid confusion.

## Examples

An instance of the app can be seen running at the [rubyweek page](http://rubyweek.org).

Screenshot: ![The activities app](screenshot.png)

## Running the app on Heroku

To deploy the app, you need the following:

* Clone this repository: `https://github.com/eurucamp/eurucamp-activities-2013/`

* An account and a created application at Heroku.
* A registered twitter application. Go [here](https://apps.twitter.com/).
* A registered github application. Go [here](https://github.com/settings/applications).

Deploying is as easy as:

* Add their keys to your Heroku app as described [here](https://devcenter.heroku.com/articles/config-vars) using the env variables described below.
* Push the repository to Heroku: `git push  git@heroku.com:<name-of-your-app>.git`

### **ENV** variables used:

* `GITHUB_KEY`: Your github application key.
* `GITHUB_SECRET`: Your github application secret.
* `TWITTER_KEY`: Your twitter application key.
* `TWITTER_SECRET`: Your twitter application secret.

## Development

An installed postgresql instance and a compiler is needed.

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
