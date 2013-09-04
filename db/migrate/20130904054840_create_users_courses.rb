class CreateUsersCourses < ActiveRecord::Migration
  def change
    create_table :users_courses do |t|
      t.string :slug
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
