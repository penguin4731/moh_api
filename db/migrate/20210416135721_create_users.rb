class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :firebase_uid
      t.string :name
    end
  end
end
