# This migration comes from talky_engine (originally 20130331042531)
class AddSlugToForums < ActiveRecord::Migration
  def change
    add_column :forums, :slug, :string
    add_index :forums, :slug, unique: true
  end
end
