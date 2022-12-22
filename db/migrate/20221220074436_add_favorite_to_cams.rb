class AddFavoriteToCams < ActiveRecord::Migration[7.0]
  def change
    add_column :cams, :favorite, :boolean, default: false
  end
end
