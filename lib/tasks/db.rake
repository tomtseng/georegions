namespace :db do
  desc 'download ZCTA shapefile and add to database table'
  task :add_zctas => :environment do
    dir = Rails.root + 'shapefile/'
    url = 'http://www2.census.gov/geo/tiger/GENZ2014/shp/cb_2014_us_zcta510_500k.zip'
    zip_path = dir + url.split('/').last
    shp_path = zip_path.to_s[0...-3] + 'shp'

    sh "wget -nc #{url} -P #{dir}"
    sh "unzip -n #{zip_path} -d #{dir}"

    RGeo::Shapefile::Reader.open(shp_path, :factory => FACTORY) do |file|
      file.each do |record|
        zcta = record['ZCTA5CE10'].to_i
        Zcta.create(:zcta => zcta, :region => record.geometry)
      end
    end
  end
end
