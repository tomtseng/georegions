RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |config|
  FACTORY = RGeo::Geographic.simple_mercator_factory

  config.default = FACTORY.projection_factory
end
