class QuestionsAddBestanswerid < ActiveRecord::Migration[5.2]
  def change
    add_column(:questions,:bestanswer_id, :integer)
  end
end
