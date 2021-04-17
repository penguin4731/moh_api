class RemoveColumnsToTips < ActiveRecord::Migration[5.2]
  def change
    remove_column :tips, :image
  end
end
