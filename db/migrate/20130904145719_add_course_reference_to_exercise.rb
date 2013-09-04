class AddCourseReferenceToExercise < ActiveRecord::Migration
  def change
    change_table :exercises do |t|
      t.references :course, index: true
    end
  end
end
