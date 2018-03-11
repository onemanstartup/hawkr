FROM ruby:2.5.0-alpine3.7
MAINTAINER Kado Nakamura <kadonakamura@protonmail.com>

# g++ musl-dev make
# needed for eventmchine

# postgresql-dev - for pg

ENV BUILD_PACKAGES bash curl-dev g++ musl-dev make postgresql-dev
# ENV RUBY_PACKAGES ruby ruby-io-console ruby-bundler

# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES && \
    # apk add $RUBY_PACKAGES && \
    rm -rf /var/cache/apk/*

RUN mkdir /usr/app
WORKDIR /usr/app

COPY Gemfile /usr/app/
COPY Gemfile.lock /usr/app/
# COPY hawkr.gemspec /usr/app/
RUN bundle install --without development test

COPY . /usr/app
