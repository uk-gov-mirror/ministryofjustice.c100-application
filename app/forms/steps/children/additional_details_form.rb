module Steps
  module Children
    class AdditionalDetailsForm < BaseForm
      attribute :children_known_to_authorities, String
      attribute :children_known_to_authorities_details, String
      attribute :children_protection_plan, String
      attribute :children_protection_plan_details, String
      attribute :children_same_parents, String
      attribute :children_same_parents_yes_details, String
      attribute :children_same_parents_no_details, String
      attribute :children_parental_responsibility_details, String
      attribute :children_residence, String
      attribute :children_residence_details, String

      def self.children_known_to_authorities_choices
        GenericYesNoUnknown.string_values
      end
      validates_inclusion_of :children_known_to_authorities, in: children_known_to_authorities_choices

      def self.children_protection_plan_choices
        GenericYesNoUnknown.string_values
      end
      validates_inclusion_of :children_protection_plan, in: children_protection_plan_choices

      def self.children_same_parents_choices
        GenericYesNo.string_values
      end
      validates_inclusion_of :children_same_parents, in: children_same_parents_choices

      def self.children_residence_choices
        ChildrenResidence.string_values
      end
      validates_inclusion_of :children_residence, in: children_residence_choices

      validates_presence_of :children_parental_responsibility_details
      validates_presence_of :children_same_parents_yes_details, if: :same_parents_yes_details_needed?
      validates_presence_of :children_same_parents_no_details,  if: :same_parents_no_details_needed?
      validates_presence_of :children_residence_details,        if: :children_residence_details_needed?

      private

      def children_known_to_authorities_value
        GenericYesNoUnknown.new(children_known_to_authorities)
      end

      def children_protection_plan_value
        GenericYesNoUnknown.new(children_protection_plan)
      end

      def children_same_parents_value
        GenericYesNo.new(children_same_parents)
      end

      def children_residence_value
        ChildrenResidence.new(children_residence)
      end

      def same_parents_yes_details_needed?
        children_same_parents.eql?(GenericYesNo::YES.to_s)
      end

      def same_parents_no_details_needed?
        children_same_parents.eql?(GenericYesNo::NO.to_s)
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
          # Some attributes are value objects and thus we need to provide their values
          attributes_map.merge(
            children_known_to_authorities: children_known_to_authorities_value,
            children_protection_plan: children_protection_plan_value,
            children_same_parents: children_same_parents_value,
            children_residence: children_residence_value
          )
        )
      end
    end
  end
end
