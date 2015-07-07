class CreateZctas < ActiveRecord::Migration
  def change
    create_table :zctas, :options => 'ENGINE=MyISAM' do |t|
      t.integer :zcta
      t.column :region, :multipolygon, :null => false, :srid => SRID
    end
    change_table :zctas do |t|
      t.index :region, :spatial => true
    end
  end
end
