class Respondent < Person
  store_accessor :address_data, :address_line_1, :address_line_2,
                 :town, :country, :postcode
end
