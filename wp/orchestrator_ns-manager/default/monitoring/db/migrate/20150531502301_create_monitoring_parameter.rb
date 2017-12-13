class CreateMonitoringParameter < ActiveRecord::Migration
  def change
    create_table :monitoring_parameters do |t|
      t.string :name
      t.string :description
      t.string :definition
      t.integer :ns_id
    end
  end
  def down
    drop_table :monitoring_parameters
  end
end
