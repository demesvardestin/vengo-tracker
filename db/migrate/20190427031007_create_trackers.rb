class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.integer :product_id
      t.integer :current_value

      t.timestamps null: false
    end
  end
end
