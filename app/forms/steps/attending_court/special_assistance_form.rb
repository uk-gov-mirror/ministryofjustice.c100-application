module Steps
  module AttendingCourt
    class SpecialAssistanceForm < BaseForm
      include ArrangementsCheckBoxesForm
      setup_attributes_for SpecialAssistance, group_name: :special_assistance

      # any other attributes
      attribute :special_assistance_details, String

      private

      # TODO: temporarily until all applications are migrated to version >= 5,
      # we copy whatever the values of the litigation capacity attributes from
      # the main `c100_application` table to the new `court_arrangement` table,
      # so when we do the cleanup of the old code and old attributes from the
      # database, we can start using the attributes in the new table easily.
      #
      def additional_attributes_map
        {
          special_assistance_details: special_assistance_details,
        }.merge(litigation_capacity_attributes)
      end

      # We just store them, we do nothing with them afterwards for now.
      # These come from `LitigationCapacityForm` and `LitigationCapacityDetailsForm`.
      #
      def litigation_capacity_attributes
        {
          reduced_litigation_capacity: c100_application.reduced_litigation_capacity,
          participation_capacity_details: c100_application.participation_capacity_details,
          participation_other_factors_details: c100_application.participation_other_factors_details,
          participation_referral_or_assessment_details: c100_application.participation_referral_or_assessment_details,
        }
      end
    end
  end
end
