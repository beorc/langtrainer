class AddShuffledToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :shuffled, :boolean, default: true
  end
end
