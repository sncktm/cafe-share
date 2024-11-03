class AddColumnsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :cafe_name, :string
    add_column :posts, :prefecture_id, :integer
    add_column :posts, :image, :string
  end
end
