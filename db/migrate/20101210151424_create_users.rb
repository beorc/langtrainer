class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :username
      t.integer :language_id

      t.timestamps
    end

    add_index :users, :email
    add_index :users, :username
  end

  def self.down
    drop_table :users
  end
end
