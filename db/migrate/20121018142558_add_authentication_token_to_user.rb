class AddAuthenticationTokenToUser < ActiveRecord::Migration
  def change
    unless column_exists? :users, :authentication_token
      add_column :users, :authentication_token, :string
      add_index :users, :authentication_token, unique: true
    end
  end
end
