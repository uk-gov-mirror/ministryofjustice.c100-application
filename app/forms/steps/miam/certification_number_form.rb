module Steps
  module Miam
    class CertificationNumberForm < BaseForm
      attribute :miam_certification_number, String

      validates_presence_of :miam_certification_number

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          miam_certification_number: miam_certification_number
        )
      end
    end
  end
end
