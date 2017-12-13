class CreateParameter < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :name
      t.string :unit
      t.string :formula
      t.references :monitoring_metric
      t.references :vnf_instance
      
    end
  end
  def down
    drop_table :parameters
  end
end
