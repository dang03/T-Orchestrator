class CreateNsInstance < ActiveRecord::Migration
  def change
    create_table :ns_instances do |t|
      t.string :ns_id
      t.string :status

      t.timestamps null: false
    end
    
  end
end
