class Tag < ApplicationRecord
	searchkick word_start: [:url]
	belongs_to :website
end
