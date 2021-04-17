class RemoveColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :questions, :refer_id
    remove_column :tips, :refer_id
  end
end
