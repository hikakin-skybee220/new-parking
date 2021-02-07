class AddStampToReserves < ActiveRecord::Migration[6.0]
  def change
    add_column :reserves, :finish_stamp, :integer
  end
end
