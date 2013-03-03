class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.references :user
      t.references :exercise
      t.boolean :atom, default: false

      t.references :sentence
      t.string :type

      t.string :english
      t.string :russian

      t.timestamps
    end
    add_index :sentences, :user_id
    add_index :sentences, :exercise_id
    add_index :sentences, :sentence_id
    add_index :sentences, :atom
    add_index :sentences, :english, unique: true
    add_index :sentences, :russian, unique: true
  end
end
