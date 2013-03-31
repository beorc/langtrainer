# This migration comes from talky_engine (originally 20130331042521)
class AddSlugToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :slug, :string
    add_index :categories, :slug, unique: true
  end
end
