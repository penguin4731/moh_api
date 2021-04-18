class AddColumnsToRefer < ActiveRecord::Migration[5.2]
  def change
    add_column(:refers , :c_type, :string)
  end
end
