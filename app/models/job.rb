class Job < ActiveRecord::Base
	belongs_to :company
	has_one :category
end
