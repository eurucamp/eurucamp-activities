FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /activities-app
WORKDIR /activities-app
COPY Gemfile /activities-app/Gemfile
COPY Gemfile.lock /activities-app/Gemfile.lock
RUN bundle install
COPY . /activities-app