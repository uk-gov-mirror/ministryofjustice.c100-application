module Steps
  module Children
    class ResidenceForm < BaseForm
      attribute :other, Boolean
      attribute :other_full_name, StrippedString

      validates_presence_of :other_full_name, if: :other?

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record.update(
          other: other,
          other_full_name: (other_full_name if other)
        )
      end
    end
  end
end
