class CreateUsersCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :slug
      t.string :title
      t.text :description
      t.references :user, index: true

      t.timestamps
    end

    add_index :courses, :slug
  end
end
