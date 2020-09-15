module Steps
  module Screener
    class PostcodeForm < BaseForm
      include HasOneAssociationForm

      has_one_association :screener_answers

      attribute :children_postcodes, StrippedString
      validates :children_postcodes, presence: true, full_uk_postcode: true

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          children_postcodes: children_postcodes
        )

        # TODO: preparation for future screener removal.
        # Soon we will get rid of the `screener_answers` DB table and
        # refactor the postcode screener question to be part of the main
        # application. For now, we just copy over this to the new DB field.
        #
        c100_application.update(
          children_postcode: children_postcodes
        )
      end
    end
  end
end
