class JobSerializer < ActiveModel::Serializer
	attributes :title,:description,:company_name,:category_name,:featured,:url,:category_id,:company_id,:published_at

	def published_at
		object.created_at.to_time.to_i
	end
 
	# attribute  :created_at, :key=> :published_at
end
