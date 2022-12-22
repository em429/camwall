class CreateCams < ActiveRecord::Migration[7.0]
  def change
    create_table :cams do |t|
      t.string :ip
      t.timestamp :shodan_timestamp
      t.string :isp
      t.string :city
      t.string :country_name
      t.string :country_code
      t.float :longitude
      t.float :latitude
      t.text :shodan_response
      t.integer :port
      t.string :screenshot

      t.timestamps
    end
  end
end
