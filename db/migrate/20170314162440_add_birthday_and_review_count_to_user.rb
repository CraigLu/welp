class AddBirthdayAndReviewCountToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :birthday, :date
    add_column :users, :review_count, :integer
  end
end
