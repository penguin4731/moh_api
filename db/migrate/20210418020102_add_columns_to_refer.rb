class AddColumnsToRefer < ActiveRecord::Migration[5.2]
  def change
    add_column(:refers , :type, :string)
  end
end
