class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.integer :user_id
      t.integer :category_id
      t.text :comment
      t.string :image
      t.string :bestanswer_id
    end
  end
end
