class Zcta < ActiveRecord::Base
  EWKB = RGeo::WKRep::WKBGenerator.new(:type_format => :ewkb,
    :emit_ewkb_srid => true, :hex_format => true)

  # returns ActiveRecord::Relation. Each element in the Relation has a .zcta
  # field (zipcode) and a .distance field (distance from given lat-lon point)
  def self.near_latlon(lat, lon, radius)
    scale = proj_to_meters_scale_factor(lat)
    radius_in_m = radius / scale
    ewkb = EWKB.generate(FACTORY.point(lon, lat).projection)
    nearby = select("id, zcta, ST_Distance(region, ST_GeomFromEWKB(E'\\\\x#{ewkb}')) AS distance")
              .where("ST_DWithin(region, ST_GeomFromEWKB(E'\\\\x#{ewkb}'), #{radius_in_m})")
              .order("distance")
    nearby.each { |zcta| zcta.distance *= scale }
  end

  private
  def self.proj_to_meters_scale_factor(lat)
    Math::cos(lat * Math::PI / 180)
  end
end
