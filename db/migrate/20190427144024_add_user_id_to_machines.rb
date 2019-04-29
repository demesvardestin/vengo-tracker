class AddUserIdToMachines < ActiveRecord::Migration
  def change
    add_column :machines, :operator_id, :integer
  end
end
