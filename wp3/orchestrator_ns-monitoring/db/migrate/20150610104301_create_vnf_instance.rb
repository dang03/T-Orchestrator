class CreateVnfInstance < ActiveRecord::Migration
  def change
    create_table :vnf_instances do |t|
      t.string :vnf_id
      t.references :monitoring_metric
      
    end
  end
  def down
    drop_table :vnf_instances
  end
end
