class CreateWebsites < ActiveRecord::Migration[5.0]
  def change
    create_table :websites do |t|
      t.string :url
      t.text :description
      t.integer :tag_id

      t.timestamps
    end
  end
end
