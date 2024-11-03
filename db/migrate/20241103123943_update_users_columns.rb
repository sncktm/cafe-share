class UpdateUsersColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :string, :string
    add_column :users, :location, :integer
  end
end
