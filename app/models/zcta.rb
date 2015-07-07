class Zcta < ActiveRecord::Base
  EWKB = RGeo::WKRep::WKBGenerator.new(:type_format => :ewkb,
    :emit_ewkb_srid => true, :hex_format => true)

  def self.containing_latlon(lat, lon)
    ewkb = EWKB.generate(FACTORY.point(lon, lat).projection)
    where("ST_Intersects(region, ST_GeomFromEWKB(E'\\\\x#{ewkb}'))")
  end

  def self.containing_geo(geom)
    ewkb = EWKB.generate(FACTORY.point(geom))
    where("ST_Intersects(region, ST_GeomFromEWKB(E'\\\\x#{ewkb}'))")
  end

  def self.near_latlon(lat, lon, radius)
    ewkb = EWKB.generate(FACTORY.point(lon, lat).projection)
    where("ST_DWithin(region, ST_GeomFromEWKB(E'\\\\x#{ewkb}'), #{radius})")
  end
end
