class CreateSlas < ActiveRecord::Migration
  def change
    create_table :slas do |t|
      t.integer :nsi_id, null: false
      
      t.timestamps null: false
    end

  end
end
