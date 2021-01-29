# README

# Pulse checker Dashboard

 - Ruby version: `3.0.0`
 - Rails version: `6.1.1`
 - DB: `Postgres`
 - node: `14.15.4`


## Start

 1. Create `.env` file: `cp .env.example .env`
 2. Run containers: `docker-compose up -d`
 3. Database setup: `rails db:setup`
 4. Run server: `rails s`
 5. Run Frontend `bin/webpack-dev-server --hot`

## Testing
 1. Run `rubocop` for check code styling.
 2. Run `brakeman` for check security vulnerabilities
 3. Run `rspec spec` for run tests.

## Debug Rails

 - Put `byebug` somewhere in .rb
