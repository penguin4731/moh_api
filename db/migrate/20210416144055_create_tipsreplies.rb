class CreateTipsreplies < ActiveRecord::Migration[5.2]
  def change
    create_table :tips_replies do |t|
      t.integer :user_id
      t.integer :tip_id
      t.text :comment
      t.string :image
    end
  end
end
