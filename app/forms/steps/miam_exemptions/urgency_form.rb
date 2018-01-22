module Steps
  module MiamExemptions
    class UrgencyForm < BaseForm
      include HasOneAssociationForm

      has_one_association :exemption

      attribute  UrgencyExemptions::GROUP_RISK, Boolean, default: false
      attributes UrgencyExemptions::RISK, Boolean, default: false

      attribute  UrgencyExemptions::GROUP_MISCARRIAGE, Boolean, default: false
      attributes UrgencyExemptions::MISCARRIAGE, Boolean, default: false

      attribute  UrgencyExemptions::URGENCY_NONE, Boolean, default: false

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
