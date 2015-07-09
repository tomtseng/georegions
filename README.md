# Geo region analysis

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

## Versions
* Ruby 2.2.1
* Rails 4.2.0

## Setup
* Install gems: `bundle install`
* Modify config/database.yml to use your mysql username and password
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

## Problems
* Distances are currently calculated by straight line on the Web Mercator
  projection. However, these rhumb lines are, in general, not the shortest
  paths. A true shortest path will be curved upon projection.
* Distances are only locally true because I am currently scaling distances
  solely based on the latitude of the original point. Given a large radius in
  which latitude changes a lot, the scale factor may change significantly.
* MySQL is not as powerful as PostGIS. For example, I am finding regions nearby
  a point by using `ST_Intersect` after calling `ST_Buffer` on a point, which is
  less efficient and less transparent than just using PostGIS's `ST_DWithin`.
  Furthermore, many of the above distance problems could perhaps be fixed by
  using a PostGIS database with geographic (rather than the current geometric)
  coordinates. With geographic coordinates in which the spheroidical nature of
  the Earth is properly accounted for, distances in meters can be calculated
  correctly. MySQL's support for geographic coordinates is weak: MySQL's
  `ST_Distance` will only work between points, but I need it to work with
  arbitrary regions like PostGIS's does. It's also not obvious to me how I can
  accurately find all regions near a point given geographic coordinates in MySQL
  (in PostGIS, I could again just use `ST_DWithin`). I could certainly find
  nearby points by fiddling with the haversine formula, but it's not obvious to
  me how to generalize this to polygons.
* Schema aren't dumped into db/schema.rb correctly. This seems to be a problem
  with adding a spatial index to the database table. (The spatial index is
  working; queries are indeed faster with it.)

## Notes
* [This article](http://daniel-azuma.com/articles/georails/part-8) was a
  valuable resource.
