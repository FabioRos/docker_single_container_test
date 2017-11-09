class AddColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_password_set, :boolean, null: false, default: false
    add_column :users, :enabled, :boolean, null: false, default: true

    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    add_reference :users, :role, foreign_key: true
  end
end
