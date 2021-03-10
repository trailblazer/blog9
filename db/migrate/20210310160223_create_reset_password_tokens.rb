class CreateResetPasswordTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :reset_password_tokens do |t|
      t.integer :user_id
      t.text    :token
      t.timestamps
    end

    add_index :reset_password_tokens, :token, unique: true
  end
end
