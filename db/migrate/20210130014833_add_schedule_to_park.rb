class AddScheduleToPark < ActiveRecord::Migration[6.0]
  def change
    add_column :parks, :finish_on_schedule, :datetime
  end
end
