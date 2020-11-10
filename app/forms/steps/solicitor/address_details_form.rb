module Steps
  module Solicitor
    class AddressDetailsForm < BaseForm
      include HasOneAssociationForm

      has_one_association :solicitor

      attribute :address, StrippedString

      validates_presence_of :address

      # Used to present the solicitor's name in the view
      delegate :full_name, to: :record_to_persist

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
