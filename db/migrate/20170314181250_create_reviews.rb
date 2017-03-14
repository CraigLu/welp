class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :description
      t.integer :user_id
      t.integer :website_id
      t.string :title

      t.timestamps
    end
  end
end
