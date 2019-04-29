class CreateMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.float :latitude
      t.float :longitude
      
      t.timestamps null: false
    end
  end
end
