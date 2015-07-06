# Geo region analysis

Goals for this project:
* import shapefile data into database
* find overlapping regions

The shapefile of choice holds ZCTA data and is found from
[census data](https://www.census.gov/geo/maps-data/data/cbf/cbf_zcta.html).

## Dependencies
* Install postgres and run `gem install pg`
  * Then, after starting up the database, run `psql` and create a user `create
    role georegions_dev with createdb login password 'pw';` (or if you already
    have a user role to use, adjust the username/password in config/database.yml
    appropriately)
  * Also in `psql`, run `CREATE EXTENSION postgis;`
* Install postgis

## Versions
* Ruby 2.2.1
* Rails 4.2.0

## Setup
* Install gems: `bundle install`
* Create db: `rake db:create`
* Run migrations: `rake db:migrate`
