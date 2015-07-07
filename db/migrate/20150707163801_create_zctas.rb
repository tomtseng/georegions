class CreateZctas < ActiveRecord::Migration
  def change
    create_table :zctas do |t|
      t.integer :zcta
      t.st_polygon :region, :srid => 3785
    end
    change_table :zctas do |t|
      t.index :region, using: :gist
    end
  end
end
