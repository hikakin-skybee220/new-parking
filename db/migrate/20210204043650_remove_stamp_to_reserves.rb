class RemoveStampToReserves < ActiveRecord::Migration[6.0]
  def change
    remove_column :reserves, :finish_stamp, :integer
    add_column :reserves, :finish_stamp, :text
  end
end
