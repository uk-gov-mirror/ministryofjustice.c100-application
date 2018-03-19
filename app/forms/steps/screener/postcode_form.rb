module Steps
  module Screener
    class PostcodeForm < BaseForm
      include HasOneAssociationForm

      has_one_association :screener_answers

      attribute :children_postcodes, String
      validates :children_postcodes, presence: true, full_uk_postcode: true

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          children_postcodes: children_postcodes
        )
      end
    end
  end
end
