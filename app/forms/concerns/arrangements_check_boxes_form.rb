module ArrangementsCheckBoxesForm
  extend ActiveSupport::Concern
  include HasOneAssociationForm

  included do
    has_one_association :court_arrangement
  end

  class_methods do
    def setup_attributes_for(value_object, attribute_name:)
      attribute attribute_name, Array[String]

      # Define the query method for each of the attributes
      # rubocop:disable Performance/HashEachMethods
      value_object.values.each do |name|
        define_method("#{name}?") do
          public_send(attribute_name).include?(name.to_s)
        end
      end
      # rubocop:enable Performance/HashEachMethods
    end
  end

  private

  def additional_attributes_map
    {}
  end

  def persist!
    raise BaseForm::C100ApplicationNotFound unless c100_application

    record_to_persist.update(
      attributes_map.merge(
        additional_attributes_map
      )
    )
  end
end
