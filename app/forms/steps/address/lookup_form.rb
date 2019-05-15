module Steps
  module Address
    class LookupForm < BaseForm
      attribute :postcode, StrippedString
      validates :postcode, presence: true, full_uk_postcode: true

      def to_partial_path
        "steps/address/lookup/#{record.type.underscore}"
      end

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application.present?

        record.update(
          postcode: postcode,
        )
      end
    end
  end
end
