class CreateMonitoringMetric < ActiveRecord::Migration
  def change
    create_table :monitoring_metrics do |t|
      t.string :nsi_id
      
    end
  end
  def down
    drop_table :monitoring_metrics
  end
end
