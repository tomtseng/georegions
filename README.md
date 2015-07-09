# Geo region analysis

(This branch is for experimenting with PostGIS again for speed testing purposes.
Currently still using inaccurate distance calculations using projected
coordinates.)

This is a project for work.

Goals for this project:
* Import shapefile data into database
* Given a region, want to be able to find other regions that are within a small
  radius

The shapefile of choice holds ZCTA data and is found from
[census data](https://www.census.gov/geo/maps-data/data/cbf/cbf_zcta.html).

## What does this thing do?
Enter in a lat-long coordinates and a radius. The site will spit out a list of
zipcode regions that are within that radius around the given point.

## Dependencies
* Install GEOS?
* Install Proj?
* Install postgres and run `gem install pg`
  * Then, aftering starting up the database, create a user with
    `psql -c "create role georegions_dev with createdb login password 'pw';"`
    (this is not very secure so don't actually do stuff like this in production)
    (or if you already have a user role to use, adjust the username/password in
    config/database.yml appropriately)

## Versions
* Ruby 2.2.1
* Rails 4.2.0

## Setup
* Install gems: `bundle install`
* Create db: `rake db:create`
* Run migrations: `rake db:migrate`
* Download the shapefile above and unzip it in a directory named "shapefile".
* Load shapefile data into database: `rails runner script/read.rb`. This will
  take a few minutes.
* Run the server: `rails server`
* Navigate to `localhost:3000`

## Potential Speedups
* Split the zipcode regions into smaller polygons
* PostgreSQL vs. MySQL

## Notes
* [This article](http://daniel-azuma.com/articles/georails/part-8) was a
  valuable resource.
