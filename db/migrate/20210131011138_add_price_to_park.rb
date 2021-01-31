class AddPriceToPark < ActiveRecord::Migration[6.0]
  def change
    add_column :parks, :price, :integer
    remove_column :parks, :finish_stamp, :integer
    add_column :parks, :finish_stamp, :text
  end
end
