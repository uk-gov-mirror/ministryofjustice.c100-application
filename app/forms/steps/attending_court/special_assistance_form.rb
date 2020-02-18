module Steps
  module AttendingCourt
    class SpecialAssistanceForm < BaseForm
      include ArrangementsCheckBoxesForm
      setup_attributes_for SpecialAssistance, group_name: :special_assistance

      # any other attributes
      attribute :special_assistance_details, String

      private

      def additional_attributes_map
        { special_assistance_details: special_assistance_details }
      end
    end
  end
end
