class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :name, :first_name
    change_column :users, :first_name, :string, null: false, default: ''
    add_column :users, :last_name, :string, null: false, default: ''
  end
end
