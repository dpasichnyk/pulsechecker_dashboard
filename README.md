# README

# Pulse checker Dashboard

 - Ruby version: `3.0.0`
 - Rails version: `6.1.1`
 - DB: `Postgres`
 - Node: `14.15.4`


## Start

 1. Create `.env` file: `cp .env.example .env` and  `cp .env.docker.example .env.docker`
 2. Run containers: `docker-compose up -d`
 3. Database setup: `docker-compose run dashboard rails db:setup`

## Testing
 1. Run `rubocop` for check code styling.
 2. Run `brakeman` for check security vulnerabilities
 3. Run `rspec spec` for run tests.

## Debug Rails

 - Put `byebug` somewhere in .rb
