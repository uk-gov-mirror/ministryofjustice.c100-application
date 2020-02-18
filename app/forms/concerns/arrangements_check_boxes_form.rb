module ArrangementsCheckBoxesForm
  extend ActiveSupport::Concern
  include HasOneAssociationForm

  included do
    has_one_association :court_arrangement
  end

  class_methods do
    attr_accessor :group_name

    def setup_attributes_for(value_object, group_name:)
      self.group_name = group_name

      attributes value_object.values, Axiom::Types::Boolean

      # We override the getter methods for each of the attributes so we
      # can retrieve their state (checked/unchecked) from the DB array column.
      attribute_names.each do |name|
        define_method(name) do
          selected_options.include?(name) || Array(record_to_persist[group_name]).include?(name.to_s)
        end

        define_method("#{name}?") do
          selected_options.include?(name)
        end
      end
    end
  end

  private

  # :nocov:
  def additional_attributes_map
    raise 'implement in subclasses'
  end
  # :nocov:

  def persist!
    raise BaseForm::C100ApplicationNotFound unless c100_application

    record_to_persist.update(
      { self.class.group_name => selected_options }.merge(additional_attributes_map)
    )
  end
end
