class CreateZctas < ActiveRecord::Migration
  def change
    create_table :zctas do |t|
      t.integer :zcta
      t.multi_polygon :region, :geographic => true
    end
    change_table :zctas do |t|
      t.index :region, using: :gist
    end
  end
end
