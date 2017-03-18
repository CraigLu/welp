class Website < ApplicationRecord
	has_many :reviews
	has_many :tags
end
