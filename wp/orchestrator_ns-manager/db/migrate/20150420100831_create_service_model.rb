class CreateServiceModel < ActiveRecord::Migration
  def change
    create_table :service_models, :force => true do |t|
      t.string :name
      t.string :path
      t.string :host
      t.integer :port
      t.string :status
    end
  end
  
  def down
#    drop_table :service_models
  end
end

