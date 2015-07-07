# Geo region analysis

Goals for this project:
* import shapefile data into database
* find overlapping regions

The shapefile of choice holds ZCTA data and is found from
[census data](https://www.census.gov/geo/maps-data/data/cbf/cbf_zcta.html).

## Dependencies
* Install GEOS
* Install Proj
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
* Run `psql -d georegions_production -c "CREATE EXTENSION postgis;` (and you
  might have to do the same for the test and production databases?)
* Run migrations: `rake db:migrate`
* Download the shapefile above and unzip it in a directory named "shapefile".
* Load shapefile data into database: `rails runner script/read.rb`
