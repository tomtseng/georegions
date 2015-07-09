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


## Problems
* Distances are currently calculated by straight line on the Web Mercator
  projection. However, these rhumb lines are, in general, not the shortest
  paths. A true shortest path will be curved upon projection. (This is not
  significant for small distances.)
* Distances are only locally true because I am currently scaling distances
  solely based on the latitude of the original point. Given a large radius in
  which latitude changes a lot, the scale factor may change significantly.
  (Again, insignificant for small distance)
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
  nearby points by fiddling with the haversine formula, but it seems like it
  would be difficult to generalize this to polygons.

## Potential Speedups
* Split the zipcode regions into smaller polygons

## Actual Speedups
* PostgreSQL vs. MySQL
  * Some informal tests suggest that PostgresSQL + PostGIS is faster, and
    significantly more so in large cases. Here's a table of database lookup
    times for zipcodes near the Space Needle. Also, PostGreSQL results are faster
    if you give the same query multiple times in a row, which gives another speedup
    of 30-60%.
```
| Distance (m) | MySQL time (ms) | PostGIS time, first request (ms) |
| ------------ | --------------- | -------------------------------- |
| 0            | 0.6             | 1.0                              |
| 100          | 0.8             | 0.8                              |
| 1000         | 0.8             | 1.8                              |
| 10000        | 2.56            | 2.6                              |
| 100000       | 57.8            | 14.4                             |
| 1000000      | 2890            | 185.6                            |
| 10000000     | 23121           | 614.5                            |
| 10000000000  | 23162           | 430.2                            |
```

These results were produced through the most excellent and rigorous method of
entering queries into the rails console by hand a couple of times.

## Notes
* [This article](http://daniel-azuma.com/articles/georails/part-8) was a
  valuable resource.
