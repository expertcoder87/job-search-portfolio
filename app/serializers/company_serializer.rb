class CompanySerializer < ActiveModel::Serializer
 	attributes :name,:username,:email,:country,:state,:city,:number_days_purchased,:number_days_remaining
 	has_many :jobs
end
