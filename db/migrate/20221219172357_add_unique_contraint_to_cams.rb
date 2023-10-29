class AddUniqueContraintToCams < ActiveRecord::Migration[7.0]
  def change
    add_index :cams, :ip, unique: true
  end
end
