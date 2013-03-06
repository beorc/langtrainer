class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :title
      t.string :slug
      t.references :user

      t.timestamps
    end
    add_index :exercises, :slug, unique: true
    add_index :exercises, :user_id
  end
end
