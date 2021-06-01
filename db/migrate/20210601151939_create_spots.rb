class CreateSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :spots do |t|
      t.string :name
      t.string :surfline_id
      t.float :lon
      t.float :lat
      t.string :country
      t.string :ideal_swell_direction
      t.string :ideal_wind_direction
      t.string :ideal_tide
      t.string :description
      t.string :ability_level
      t.string :vibe
      t.string :access
      t.timestamps
    end
  end
end
