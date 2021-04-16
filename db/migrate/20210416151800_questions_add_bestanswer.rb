class QuestionsAddBestanswer < ActiveRecord::Migration[5.2]
  def change
    add_column(:questions,:bestanswer_id, :string)
  end
end
