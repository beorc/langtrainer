# This migration comes from talky_engine (originally 20130331042605)
class AddSlugToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :slug, :string
    add_index :topics, :slug, unique: true
  end
end
