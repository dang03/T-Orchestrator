class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.references :sla, index: true
      t.string :name, null: false
      t.float :minimum
      t.float :maximum
      t.float :threshold

      t.timestamps null: false
    end

#    add_index :parameters, :name, unique: true
  end
end
