require 'rgeo-shapefile'

path = (Rails.root + 'shapefile/cb_2014_us_zcta510_500k.shp').to_s

RGeo::Shapefile::Reader.open(path, :factory => FACTORY) do |file|
  file.each do |record|
    zcta = record['ZCTA5CE10'].to_i
    record.geometry.projection.each do |poly|
      Zcta.create(:zcta => zcta, :region => poly)
    end
  end
end
