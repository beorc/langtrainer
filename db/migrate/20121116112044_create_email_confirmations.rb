class CreateEmailConfirmations < ActiveRecord::Migration
  def change
    create_table :email_confirmations do |t|
      t.belongs_to :user
      t.string :new_email
      t.string :token

      t.timestamps
    end

    add_index :email_confirmations, :new_email
    add_index :email_confirmations, :user_id
    add_index :email_confirmations, :token, unique: true
  end
end
