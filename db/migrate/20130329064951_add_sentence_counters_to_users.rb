class AddSentenceCountersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :en_counter, :integer, default: 0
    add_column :users, :ru_counter, :integer, default: 0
  end
end
