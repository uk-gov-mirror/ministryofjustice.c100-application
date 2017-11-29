module Steps
  module Miam
    class CertificationDateForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :miam_certification_date, Date

      acts_as_gov_uk_date :miam_certification_date

      validates_presence_of :miam_certification_date

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          miam_certification_date: miam_certification_date
        )
      end
    end
  end
end
