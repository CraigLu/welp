class User < ApplicationRecord
	has_many :reviews
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :user_img, :styles => {profile: "100x100#", :large => "500x500>" }, default_url: "http://www.diybackyardworkshop.com/wp-content/uploads/2012/01/NoAvatar.png"  
  validates_attachment_content_type :user_img, content_type: /\Aimage\/.*\z/
  acts_as_voter
end
