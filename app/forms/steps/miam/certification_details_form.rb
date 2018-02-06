module Steps
  module Miam
    class CertificationDetailsForm < BaseForm
      attribute :miam_certification_number, String
      attribute :miam_certification_service_name, String
      attribute :miam_certification_sole_trader_name, String

      validates_presence_of :miam_certification_number,
                            :miam_certification_service_name,
                            :miam_certification_sole_trader_name

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          attributes_map
        )
      end
    end
  end
end
