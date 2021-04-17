class DropTipsreplies < ActiveRecord::Migration[5.2]
  def change
    drop_table :tips_replies
  end
end
