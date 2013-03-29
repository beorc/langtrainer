class AddLanguageToForums < ActiveRecord::Migration
  def change
    add_column :forums, :language, :string
  end
end
