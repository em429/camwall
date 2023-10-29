class AddMoreFieldsToCams < ActiveRecord::Migration[7.0]
  def change
    add_column :cams, :asn, :string
    add_column :cams, :org, :string
    add_column :cams, :os, :string
  end
end
