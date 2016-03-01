class ProfileSerializer < ActiveModel::Serializer
    attributes :id,:first_name,:last_name,:company_name,:current_title,:summary,:skills,:experience_company,:experience_title,:experience_start_date,:experience_end_date,:experience_description,:school_name,:major,:education_start_date,:education_end_date,:allow_to_be_searched,:looking_for
end    

