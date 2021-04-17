class RemoveTypeToRefers < ActiveRecord::Migration[5.2]
  def change
    remove_column :refers, :type
  end
end
