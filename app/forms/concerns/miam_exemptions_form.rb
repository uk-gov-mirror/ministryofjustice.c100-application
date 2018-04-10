module MiamExemptionsForm
  extend ActiveSupport::Concern
  include HasOneAssociationForm

  included do
    has_one_association :miam_exemption
    validate :at_least_one_checkbox_validation
  end

  class_methods do
    attr_accessor :group_name, :none_name

    def setup_attributes_for(value_object, group_name:, none_name: nil)
      self.group_name = group_name
      self.none_name  = none_name || :"#{group_name}_none"

      attributes value_object.values, Axiom::Types::Boolean

      # We override the getter methods for each of the exemption attributes so we
      # can retrieve their state (checked/unchecked) from the DB array column.
      attribute_names.each do |name|
        define_method(name) { record_to_persist[group_name].include?(name.to_s) }
      end
    end
  end

  private

  # We filter out `group_xxx` items, as the purpose of these are to present the exemptions
  # in groups for the user to show/hide them, and are not really an exemption by itself.
  #
  def valid_options
    selected_options.grep_v(/\Agroup_/)
  end

  def at_least_one_checkbox_validation
    errors.add(self.class.none_name, :blank) unless valid_options.any?
  end

  def persist!
    raise BaseForm::C100ApplicationNotFound unless c100_application

    record_to_persist.update(
      self.class.group_name => selected_options
    )
  end
end
