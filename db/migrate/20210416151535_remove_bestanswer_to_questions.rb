class RemoveBestanswerToQuestions < ActiveRecord::Migration[5.2]
  def change
    remove_column :questions ,:bestanswer_id
  end
end
