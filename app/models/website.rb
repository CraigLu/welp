class Website < ApplicationRecord
	searchkick word_start: [:url]
	has_many :reviews
	has_many :tags
end
