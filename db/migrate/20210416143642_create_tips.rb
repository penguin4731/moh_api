class CreateTips < ActiveRecord::Migration[5.2]
  def change
    create_table :tips do |t|
      t.integer :user_id
      t.integer :category_id
      t.text :comment
      t.string :image
    end
  end
end
