# This migration comes from sitemplate_core_engine (originally 20121205083809)
class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :message
      t.string :email
      t.references :user

      t.timestamps
    end

    add_index :feedbacks, :user_id
  end
end
