class ChangeTagIdInWebsites < ActiveRecord::Migration[5.0]
  def change
  	change_column :websites, :tag_id, :integer
  end
end
