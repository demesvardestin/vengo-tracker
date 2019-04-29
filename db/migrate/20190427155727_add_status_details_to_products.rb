class AddStatusDetailsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :inventory_status, :string
    add_column :products, :threshold, :integer
  end
end
