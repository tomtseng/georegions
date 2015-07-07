class ZctaController < ApplicationController
  def lookup
    lat = params[:lat].to_f
    lon = params[:lon].to_f
    zcta = Zcta.containing_latlon(lat, lon).first
    render(:json => {:lat => lat, :lon => lon,
      :zcta => zcta ? zcta.zcta : nil})
  end
end
