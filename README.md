= Geo region analysis 

Goals for this project:
* import shapefile data into database
* find overlapping regions

== Dependencies
* Install postgres and run `gem install pg`
  * Then, after starting up the database, run `psql` and create a user `create
    role georegions_dev with createdb login password 'pw';`
* Install postgis

== Versions
* Ruby 2.2.1
* Rails 4.2.0

== Setup
* Install gems: `bundle install`
* Create db: `rake db:create`
