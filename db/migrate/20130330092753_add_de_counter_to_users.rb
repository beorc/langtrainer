class AddDeCounterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :de_counter, :integer, default: 0
  end
end
