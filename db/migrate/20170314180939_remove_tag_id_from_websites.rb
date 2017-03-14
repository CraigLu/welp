class RemoveTagIdFromWebsites < ActiveRecord::Migration[5.0]
  def change
  	remove_column :websites, :tag_id
  end
end
