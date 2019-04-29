class AddSecretTokenToOperators < ActiveRecord::Migration
  def change
    add_column :operators, :secret_token, :string, default: ""
  end
end
