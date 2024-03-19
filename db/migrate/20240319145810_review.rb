class Review < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :posting_id
      t.text :suggestions
      t.timestamps
    end
  end
end
