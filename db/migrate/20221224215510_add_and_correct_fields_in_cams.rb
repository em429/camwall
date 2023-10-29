class AddAndCorrectFieldsInCams < ActiveRecord::Migration[7.0]
  def change
    add_column :cams, :screenshot_mime, :string, default: 'image/jpeg'
    change_column :cams, :screenshot, :blob, default: nil
  end
end
