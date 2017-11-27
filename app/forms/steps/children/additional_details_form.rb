module Steps
  module Children
    class AdditionalDetailsForm < BaseForm
      attribute :children_known_to_authorities, YesNoUnknown
      attribute :children_known_to_authorities_details, String
      attribute :children_protection_plan, YesNoUnknown
      attribute :children_protection_plan_details, String
      attribute :children_same_parents, YesNo
      attribute :children_same_parents_yes_details, String
      attribute :children_same_parents_no_details, String
      attribute :children_parental_responsibility_details, String
      attribute :children_residence, String
      attribute :children_residence_details, String

      def self.children_residence_choices
        ChildrenResidence.string_values
      end
      validates_inclusion_of :children_residence, in: children_residence_choices

      validates_inclusion_of :children_known_to_authorities, in: GenericYesNoUnknown.values
      validates_inclusion_of :children_protection_plan,      in: GenericYesNoUnknown.values
      validates_inclusion_of :children_same_parents,         in: GenericYesNo.values

      validates_presence_of :children_parental_responsibility_details
      validates_presence_of :children_same_parents_yes_details, if: -> { children_same_parents&.yes? }
      validates_presence_of :children_same_parents_no_details,  if: -> { children_same_parents&.no? }
      validates_presence_of :children_residence_details,        if: :children_residence_details_needed?

      private

      def children_residence_value
        ChildrenResidence.new(children_residence)
      end

      def children_residence_details_needed?
        children_residence.eql?(ChildrenResidence::OTHER.to_s)
      end

      # TODO: we don't know if any of these attributes might affect future steps, and if so, what
      # linked attributed should we reset when the form answers are changed, so not implementing this yet.
      def changed?
        true
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application
        return true unless changed?

        c100_application.update(
          # Some attributes are value objects and thus we need to provide their values,
          # but eventually we may end up with the same solution as for `YesNo` attributes.
          attributes_map.merge(
            children_residence: children_residence_value
          )
        )
      end
    end
  end
end
