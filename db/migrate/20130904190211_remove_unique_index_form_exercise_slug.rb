class RemoveUniqueIndexFormExerciseSlug < ActiveRecord::Migration
  def up
    remove_index :exercises, :slug
    add_index :exercises, :slug
    add_index :exercises, [:slug, :course_id]
  end

  def down
    remove_index :exercises, :slug
    remove_index :exercises, [:slug, :course_id]
    add_index :exercises, :slug, unique: true
  end
end
