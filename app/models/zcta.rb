class Zcta < ActiveRecord::Base
  EWKB = RGeo::WKRep::WKBGenerator.new(:type_format => :ewkb,
    :emit_ewkb_srid => true, :hex_format => true)

  # returns ActiveRecord::Relation. Each element in the Relation has a .zcta
  # field (zipcode) and a .distance field (distance from given lat-lon point)
  def self.near_latlon(lat, lon, radius)
    ewkb = EWKB.generate(FACTORY.point(lon, lat))
    select("id, zcta, ST_Distance(region, ST_GeomFromEWKB(E'\\\\x#{ewkb}')) AS distance")
      .where("ST_DWithin(region, ST_GeomFromEWKB(E'\\\\x#{ewkb}'), #{radius})")
      .order("distance")
  end
end
