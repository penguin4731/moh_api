class RenameColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :questions, :category_id , :refer_id
    rename_column :tips, :category_id , :refer_id
  end
end
