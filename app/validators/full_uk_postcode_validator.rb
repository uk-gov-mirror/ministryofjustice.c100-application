class FullUkPostcodeValidator < ActiveModel::EachValidator
  def parsed_postcode(postcode)
    UKPostcode.parse(postcode)
  end

  def validate_each(record, attribute, value)
    entries = value.to_s.split('\n').reject(&:blank?).compact
    entries.each do |entry|
      unless parsed_postcode(entry).full_valid?
        record.errors[attribute] << I18n.t(:invalid, scope: [:errors, :attributes, :children_postcodes])
      end
    end
  end
end
