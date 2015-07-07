# Geo region analysis

This is a project for work.

Goals for this project:
* Import shapefile data into database
* Given a region, want to be able to find other regions that are within a small
  radius

The shapefile of choice holds ZCTA data and is found from
[census data](https://www.census.gov/geo/maps-data/data/cbf/cbf_zcta.html).

## Dependencies
* Install GEOS?
* Install Proj?

## Versions
* Ruby 2.2.1
* Rails 4.2.0

## Setup
* Install gems: `bundle install`
* Modify config/database.yml to use your mysql username and password
* Create db: `rake db:create`
* Run migrations: `rake db:migrate`
* Download the shapefile above and unzip it in a directory named "shapefile".
* Load shapefile data into database: `rails runner script/read.rb`
* Run the server: `rails server`

## Notes
* The location model is currently unused, and there are unused functions in the
  ZCTA model.
* [This article](http://daniel-azuma.com/articles/georails/part-8) was a
  valuable resource. Most of the content in this repository is thanks to that
  article.
