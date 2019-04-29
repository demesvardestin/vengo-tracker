class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, default: ''
      t.integer :machine_id
      t.integer :current_inventory_count
      t.integer :max_inventory_count
      
      t.timestamps null: false
    end
  end
end
