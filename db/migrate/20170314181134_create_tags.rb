class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.integer :website_id
      t.string :title

      t.timestamps
    end
  end
end
