class CreateVerifyAccountTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :verify_account_tokens do |t|
      t.integer :user_id
      t.text    :token
      t.timestamps
    end

    add_index :verify_account_tokens, :token, unique: true
  end
end
