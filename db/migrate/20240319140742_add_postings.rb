class AddPostings < ActiveRecord::Migration[7.0]
  def change
    create_table :postings do |t|
      t.text :content
      t.integer :user_id
      t.text :state
      t.text :slug
      t.timestamps
    end
  end
end
