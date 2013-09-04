class CreateUsersCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :slug
      t.string :title
      t.text :description
      t.references :user, index: true

      t.timestamps
    end

    add_index :courses, [:slug, :user_id], unique: true
    add_index :courses, [:title, :user_id], unique: true
  end
end
