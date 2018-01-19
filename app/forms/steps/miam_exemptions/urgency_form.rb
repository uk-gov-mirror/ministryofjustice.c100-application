module Steps
  module MiamExemptions
    class UrgencyForm < BaseForm
      include HasOneAssociationForm

      has_one_association :exemption

      attribute :group_risk, Boolean
      attribute :risk_applicant, Boolean
      attribute :risk_unreasonable_hardship, Boolean
      attribute :risk_children, Boolean
      attribute :risk_unlawful_removal_retention, Boolean

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          attributes_map
        )
      end
    end
  end
end
