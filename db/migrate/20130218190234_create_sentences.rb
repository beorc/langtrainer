class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.references :user
      t.references :exercise
      t.boolean :atom, default: false

      t.references :sentence
      t.string :type

      t.string :en
      t.string :ru

      t.integer :position

      t.timestamps
    end
    add_index :sentences, :user_id
    add_index :sentences, :exercise_id
    add_index :sentences, [:user_id, :exercise_id]
    add_index :sentences, :sentence_id
    add_index :sentences, [:user_id, :sentence_id]
    add_index :sentences, :atom
    add_index :sentences, :position
  end
end
