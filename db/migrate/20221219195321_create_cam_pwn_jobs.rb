class CreateCamPwnJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :cam_pwn_jobs do |t|

      t.timestamps
    end
  end
end
