class AddPriceStampToReserve < ActiveRecord::Migration[6.0]
  def change
    add_column :reserves, :price_stamp, :text
  end
end
