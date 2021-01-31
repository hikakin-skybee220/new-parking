class AddStampToPark < ActiveRecord::Migration[6.0]
  def change
    add_column :parks, :finish_stamp, :integer
  end
end
