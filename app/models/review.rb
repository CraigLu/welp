class Review < ApplicationRecord
	belongs_to :website
	belongs_to :user

	acts_as_votable
end
