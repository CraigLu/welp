class AddAttachmentUserImgToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :user_img
    end
  end

  def self.down
    remove_attachment :users, :user_img
  end
end
