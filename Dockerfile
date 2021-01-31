FROM ruby:3.0-slim-buster

RUN apt-get update -y && \
   apt-get upgrade -y && \
   apt-get install -y --fix-missing \
   build-essential \
   postgresql-contrib \
   libpq-dev \
   libyaml-dev \
   git-core \
   pkg-config \
   cmake \
   curl

RUN curl -L https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 --output /usr/bin/jq && chmod +x /usr/bin/jq

ENV APP_DIR=/code

ENV LANG=C.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=C.UTF-8

WORKDIR $APP_DIR
ADD Gemfile $APP_DIR/
ADD Gemfile.lock $APP_DIR/
ADD .gemrc $APP_DIR/
RUN bundle install --jobs 4 --retry 3
ADD . $APP_DIR
RUN mkdir log

VOLUME ["$APP_DIR/public"]

EXPOSE 3000

CMD /bin/bash
