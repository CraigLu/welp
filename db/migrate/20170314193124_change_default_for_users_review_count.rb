class ChangeDefaultForUsersReviewCount < ActiveRecord::Migration[5.0]
  def change
  	change_column :users, :review_count, :integer, :default => 0
  end
end
