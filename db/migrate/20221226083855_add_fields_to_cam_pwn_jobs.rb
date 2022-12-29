class AddFieldsToCamPwnJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :cam_pwn_jobs, :query, :string
  end
end
