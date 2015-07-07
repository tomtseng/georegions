# Geo region analysis

This is a project for work.

Goals for this project:
* Import shapefile data into database
* Given a region, want to be able to find other regions that are within a small
  radius

The shapefile of choice holds ZCTA data and is found from
[census data](https://www.census.gov/geo/maps-data/data/cbf/cbf_zcta.html).

## Dependencies
* Install GEOS
* Install Proj
* Install postgres and run `gem install pg`
  * Then, after starting up the database, create a user with `psql -c "create
    role georegions_dev with createdb login password 'pw';"` (or if you already
    have a user role to use, adjust the username/password in config/database.yml
    appropriately)
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
* Run the server: `rails server`

## Notes
* I chose PostgreSQL because I heard that it has better support for spatial
  objects. However, MySQL actually should be fine if it is version 5.6.1+. The
  problem that I thought MySQL had was that it calculated intersections of
  objects using only the minimum bounding rectangles, but as of version 5.6.1,
  MySQL implements `ST_Intersects` which calculates intersections with actual
  geometry.
* The location model is currently unused, and there are unused functions in the
  ZCTA model.
* [This article](http://daniel-azuma.com/articles/georails/part-8) was a
  valuable resource. Note that it is outdated in some places. For example,
  `rset_rgeo_factory_for_column` is deprecated in RGeo. Nonetheless, most of the
  content in this repository is thanks to that article.
