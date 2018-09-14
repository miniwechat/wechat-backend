class CreateScans < ActiveRecord::Migration[5.1]
  def change
    create_table :scans do |t|
      t.string :openid
      t.string :lng_sec
      t.string :lat_sec
      t.string :scanTime_sec

      t.timestamps
    end
  end
end
