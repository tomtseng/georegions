class Zcta < ActiveRecord::Base
  FACTORY = RGeo::Geographic.simple_mercator_factory

  set_rgeo_factory_for_column(:region, FACTORY.projection_factory)

  EWKB = RGeo::WKRep::WKBGenerator.new(:type_format => :ewkb,
    :emit_ewkb_srid => true, :hex_format => true)

  def self.near_latlon(lat, lon, radius)
    scale = proj_to_meters_scale_factor(lat)
    radius_in_m = radius / scale
    point = FACTORY.point(lon, lat).projection
    nearby_raw = where("ST_Intersects(region, ST_Buffer(ST_GeomFromWKB('#{point.as_binary}', #{point.srid}), #{radius_in_m}))")
    nearby = nearby_raw.map { |zcta|
      {
        :zcta => zcta.zcta,
        :distance => point.distance(FACTORY.projection_factory.multi_polygon(zcta.region)) * scale
      }
    }
    nearby.sort_by { |k| k[:distance] }
  end

  private
  def self.proj_to_meters_scale_factor(lat)
    Math::cos(lat * Math::PI / 180)
  end
end
