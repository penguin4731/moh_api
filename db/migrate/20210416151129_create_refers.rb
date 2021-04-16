class CreateRefers < ActiveRecord::Migration[5.2]
  def change
    create_table :refers do |t|
      t.boolean :type
      t.integer :category_id
      t.integer :post_id
    end
  end
end
