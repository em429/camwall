class CreateShodanApiKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :shodan_api_keys do |t|
      t.string :key, not: nil
      t.string :plan
      t.integer :query_credit_limit
      t.integer :scan_credit_limit
      t.integer :monitored_ip_limit

      t.timestamps
    end
  end
end
