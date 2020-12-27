class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.integer   :post_id
      t.integer   :editor_id
      t.text      :suggestions
      t.text      :state
      t.timestamps
    end
  end
end
