class Review < ApplicationRecord
	belongs_to :website
	belongs_to :user
end
