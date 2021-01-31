class CreatePurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :purchases do |t|
      t.integer :reservation_id
      t.integer :no_reservation_id
      t.datetime :start_on
      t.datetime :finish_on

      t.timestamps
    end
  end
end
