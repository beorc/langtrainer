class AddDeToSentences < ActiveRecord::Migration
  def change
    add_column :sentences, :de, :string
  end
end
