class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name, :limit => 20
      t.string :hex, :limit => 10
    end

    add_index :roles, :name
  end
end
