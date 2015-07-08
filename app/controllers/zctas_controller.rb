class ZctasController < ApplicationController
  def lookup
    lat = params[:lat].to_f
    lon = params[:lon].to_f
    radius = params[:radius].to_f
    @nearby = Zcta.near_latlon(lat, lon, radius)
  end
end
