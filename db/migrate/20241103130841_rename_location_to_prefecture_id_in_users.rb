class RenameLocationToPrefectureIdInUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :location, :prefecture_id
  end
end
