class CreateZcta < ActiveRecord::Migration
  def change
    create_table :zcta do |t|
      t.integer :zcta
      t.st_polygon :region, :srid => 3785, :spatial => true
    end
  end
end
