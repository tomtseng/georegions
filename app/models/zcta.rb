class Zcta < ActiveRecord::Base
  FACTORY = RGeo::Geographic.simple_mercator_factory

  set_rgeo_factory_for_column(:region, FACTORY.projection_factory)

  # returns ActiveRecord::Relation. Each element in the Relation has a .zcta
  # field (zipcode) and a .distance field (distance from given lat-lon point)
  def self.near_latlon(lat, lon, radius)
    scale = proj_to_meters_scale_factor(lat)
    radius_in_proj_dist = radius / scale
    point = FACTORY.point(lon, lat).projection
    nearby = select("id, zcta, ST_Distance(region, ST_GeomFromWKB('#{point.as_binary}', #{point.srid})) AS distance")
              .where("ST_Intersects(region, ST_Buffer(ST_GeomFromText(?, ?), ?))", point.as_text, point.srid, radius_in_proj_dist)
              .order("distance")
    nearby.each { |zcta| zcta.distance *= scale }
  end

  private
    def self.proj_to_meters_scale_factor(lat)
      Math::cos(lat * Math::PI / 180)
    end
end
