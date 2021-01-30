class AddDateToPark < ActiveRecord::Migration[6.0]
  def change
    add_column :parks, :start_on, :datetime
    add_column :parks, :finish_on, :datetime
  end
end
