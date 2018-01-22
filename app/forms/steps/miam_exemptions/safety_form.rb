module Steps
  module MiamExemptions
    class SafetyForm < BaseForm
      include HasOneAssociationForm

      has_one_association :exemption

      attribute  SafetyExemptions::GROUP_POLICE, Boolean, default: false
      attributes SafetyExemptions::POLICE, Boolean, default: false

      attribute  SafetyExemptions::GROUP_COURT, Boolean, default: false
      attributes SafetyExemptions::COURT, Boolean, default: false

      attribute  SafetyExemptions::GROUP_SPECIALIST, Boolean, default: false
      attributes SafetyExemptions::SPECIALIST, Boolean, default: false

      attribute  SafetyExemptions::GROUP_LOCAL_AUTHORITY, Boolean, default: false
      attributes SafetyExemptions::LOCAL_AUTHORITY, Boolean, default: false

      attribute  SafetyExemptions::GROUP_DA_SERVICE, Boolean, default: false
      attributes SafetyExemptions::DA_SERVICE, Boolean, default: false

      attribute  SafetyExemptions::RIGHT_TO_REMAIN, Boolean, default: false
      attribute  SafetyExemptions::FINANCIAL_ABUSE, Boolean, default: false
      attribute  SafetyExemptions::SAFETY_NONE, Boolean, default: false

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
