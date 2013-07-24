class AddEsToSentences < ActiveRecord::Migration
  def change
    add_column :sentences, :es, :string
  end
end
