module Steps
  module AttendingCourt
    class SpecialArrangementsForm < BaseForm
      include ArrangementsCheckBoxesForm
      setup_attributes_for SpecialArrangements, group_name: :special_arrangements

      # any other attributes
      attribute :special_arrangements_details, String

      private

      def additional_attributes_map
        { special_arrangements_details: special_arrangements_details }
      end
    end
  end
end
