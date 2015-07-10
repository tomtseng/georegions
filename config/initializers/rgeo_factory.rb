RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |config|
  FACTORY = RGeo::Geographic.spherical_factory(:srid => 4326)

  config.default = FACTORY
end
