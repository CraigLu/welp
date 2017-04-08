class Tag < ApplicationRecord
	searchkick word_start: [:title]
	belongs_to :website
end
