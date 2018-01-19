module Steps
  module MiamExemptions
    class SafetyForm < BaseForm
      include HasOneAssociationForm

      has_one_association :exemption

      attribute :group_police, Boolean
      attribute :police_arrested, Boolean
      attribute :police_caution, Boolean
      attribute :police_ongoing_proceedings, Boolean
      attribute :police_conviction, Boolean
      attribute :police_dvpn, Boolean

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
