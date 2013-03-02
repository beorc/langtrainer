class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :native_language
      t.string :foreign_language

      t.timestamps
    end

    add_index :users, :email
    add_index :users, :username
  end

  def self.down
    drop_table :users
  end
end
