FROM ruby:3.0-slim-buster

RUN apt-get update -y && \
   apt-get upgrade -y && \
   apt-get install -y --fix-missing \
   build-essential \
   postgresql-contrib \
   libpq-dev \
   libyaml-dev \
   libsqlite3-dev \
   git-core \
   pkg-config \
   cmake \
   curl

RUN curl -L https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 --output /usr/bin/jq && chmod +x /usr/bin/jq
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

RUN apt-get install -y \
    yarn \
    nodejs

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
RUN rm -rf node_modules vendor
RUN yarn
RUN mkdir log

VOLUME ["$APP_DIR/public"]

EXPOSE 3000

CMD /bin/bash
