class CreateHelpfuls < ActiveRecord::Migration[5.0]
  def change
    create_table :helpfuls do |t|
      t.integer :review_id
      t.integer :user_id
      t.boolean :helpful
      t.integer :owner_id

      t.timestamps
    end
  end
end
