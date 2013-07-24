class AddEsCounterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :es_counter, :integer, default: 0
  end
end
