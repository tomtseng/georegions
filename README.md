# Geo region analysis

This is a project for work.

Goals for this project:
* Import shapefile data into database
  * The shapefile of choice holds ZCTA data from the U.S. census and is found
    [here](https://www.census.gov/geo/maps-data/data/cbf/cbf_zcta.html).
* Given a region, want to be able to find other regions that are within a small
  radius

This master branch uses MySQL and can only approximate distances. Check the
other branches for a PostGIS version and an accurate version.

## What does this thing do?
Enter in a lat-long coordinates and a radius. The site will spit out a list of
zipcode regions that are within that radius around the given point.

## Dependencies
* MySQL
* GEOS?
* Proj?

## Versions
* Ruby 2.2.1
* Rails 4.2.0
* MySQL 5.6.25

## Setup
* Install gems: `bundle install`
* Modify config/database.yml to use your mysql username and password (this
  probably isn't very secure?)
* Create db: `rake db:create`
* Setup db: `rake db:setup`
* Download the shapefile above and unzip it in the directory named "shapefile".
* Load shapefile data into database: `rails runner script/read.rb`. This will
  take a few minutes.
* Run the server: `rails server`
* Navigate to `localhost:3000`

## Issues
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
  Many of the above distance problems can be solved by using a PostGIS database
  with geographic (rather than the current geometric) coordinates. With
  geographic coordinates in which the spheroidal shape of the Earth is
  properly accounted for, distances in meters can be calculated correctly.
  MySQL's support for geographic coordinates is weak: MySQL's `ST_Distance` will
  only work between points, but I need it to work with arbitrary regions like
  PostGIS's does. It's also not obvious to me how I can accurately find all
  regions near a point given geographic coordinates in MySQL (in PostGIS, I
  could again just use `ST_DWithin`). I could certainly find nearby points by
  fiddling with the haversine formula, but it seems like it would be difficult
  to generalize this to polygons.


## Potential Speedups
* Split the zipcode regions into smaller polygons

## Actual Speedups
* PostgreSQL vs. MySQL
  * Some informal tests suggest that PostgresSQL + PostGIS is faster, and
    significantly more so in large cases. Here's a table of database lookup
    times for zipcodes near the Space Needle. Also, PostGreSQL results are faster
    if you give the same query multiple times in a row, which gives another speedup
    of 30-60% on my machine. I've also included in the last column the speed of
    queries using accurate calculations in PostGIS.

```
| Distance (m) | MySQL time (ms) | PostGIS time, first request (ms) | PostGIS accurate (ms) |
| ------------ | --------------- | -------------------------------- | --------------------- |
| 0            | 0.6             | 1.0                              | 1.2                   |
| 100          | 0.8             | 0.8                              | 0.9                   |
| 1000         | 0.8             | 1.8                              | 1.7                   |
| 10000        | 2.56            | 2.6                              | 7.3                   |
| 100000       | 57.8            | 14.4                             | 96.1                  |
| 1000000      | 2890            | 185.6                            | 1357.2                |
| 10000000     | 23121           | 614.5                            | 9092.2                |
| 10000000000  | 23162           | 430.2                            | 8886.3                |
```

These results were produced through the most excellent and rigorous method of
entering queries into the rails console by hand on my laptop a couple of times.

## Error in distance
The amount of error attributable to the projection is small locally. Within 100
miles of the Space Needle, the amount of error (compared to PostGIS using
geographic coordinates) averages to less than half of a percent. (The data used
can be found in the "distanceData" folder.)

## Notes
* [This article](http://daniel-azuma.com/articles/georails/part-8) was a
  valuable resource.
* Don't bother running `rake test` because none of the tests work.
