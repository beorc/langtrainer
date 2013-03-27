# This migration comes from talky_engine (originally 20130327135546)
class CreateForumsTable < ActiveRecord::Migration
  def self.up
    create_table :forums, :force => true do |t|
      t.string   :title
      t.text     :description
      t.boolean  :state, :default => true
      t.integer  :topics_count, :default => 0
      t.integer  :posts_count, :default => 0
      t.integer  :position, :default => 0
      t.integer  :category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :forums
  end
end