class RenameScreenshotColumnInCams < ActiveRecord::Migration[7.0]
  def change
    rename_column :cams, :screenshot, :screenshot_data
  end
end
