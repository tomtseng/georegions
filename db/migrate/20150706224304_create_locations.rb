class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations, :options => 'ENGINE=MyISAM' do |t|
      t.string :name
      t.column :loc, :point, :null => false, :srid => 3785

      t.timestamps null: false
    end
    change_table :locations do |t|
      t.index :loc, :spatial => true
    end
  end
end
