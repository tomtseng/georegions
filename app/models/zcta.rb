class Zcta < ActiveRecord::Base
  FACTORY = RGeo::Geographic.simple_mercator_factory
  set_rgeo_factory_for_column(:region, FACTORY.projection_factory)

  EWKB = RGeo::WKRep::WKBGenerator.new(:type_format => :ewkb,
    :emit_ewkb_srid => true, :hex_format => true)

  def self.near_latlon(lat, lon, radius)
    wkb = FACTORY.point(lon, lat).projection.as_binary
    where("ST_Intersects(region, ST_Buffer(ST_GeomFROMWKB('#{wkb}', #{SRID}), #{radius}))")
  end
end
