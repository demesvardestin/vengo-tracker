class AddOperatorToMachine < ActiveRecord::Migration
  def change
    add_column :machines, :operator, :string
  end
end
