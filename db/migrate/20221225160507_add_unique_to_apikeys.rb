class AddUniqueToApikeys < ActiveRecord::Migration[7.0]
  def change
    add_index :shodan_api_keys, :key, unique: true
  end
end
