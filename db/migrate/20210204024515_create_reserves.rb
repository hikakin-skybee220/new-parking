class CreateReserves < ActiveRecord::Migration[6.0]
  def change
    create_table :reserves do |t|
      t.integer :user_id
      t.datetime :start_on
      t.datetime :finish_on
      t.integer :price

      t.timestamps
    end
  end
end
