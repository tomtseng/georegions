class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.st_point :loc, :srid => 3785

      t.timestamps null: false
    end
    change_table :locations do |t|
      t.index :loc, using: :gist # creates PostGIS spatial index
    end
  end
end
