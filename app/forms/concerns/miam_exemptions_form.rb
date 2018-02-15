module MiamExemptionsForm
  extend ActiveSupport::Concern
  include HasOneAssociationForm

  included do
    has_one_association :miam_exemption
  end

  class_methods do
    attr_accessor :group_name

    def setup_attributes_for(value_object, group_name:)
      self.group_name = group_name

      attributes value_object.values, Axiom::Types::Boolean

      # We override the getter methods for each of the exemption attributes so we
      # can retrieve their state (checked/unchecked) from the DB array column.
      attribute_names.each do |name|
        define_method(name) { record_to_persist[group_name].include?(name.to_s) }
      end
    end
  end

  private

  def persist!
    raise BaseForm::C100ApplicationNotFound unless c100_application

    record_to_persist.update(
      self.class.group_name => selected_options
    )
  end
end
