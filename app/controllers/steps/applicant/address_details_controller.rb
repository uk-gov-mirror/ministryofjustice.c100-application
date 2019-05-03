module Steps
  module Applicant
    class AddressDetailsController < Steps::ApplicantStepController
      def edit
        @form_object = AddressDetailsForm.new(
          address: current_record.address,
          address_line_1: current_record.address_line_1,
          address_line_2: current_record.address_line_2,
          town: current_record.town,
          country: current_record.country,
          postcode: current_record.postcode,
          residence_requirement_met: current_record.residence_requirement_met,
          residence_history: current_record.residence_history,
          c100_application: current_c100_application,
          record: current_record
        )
      end

      def update
        update_and_advance(
          AddressDetailsForm,
          record: current_record,
          as: :address_details
        )
      end
    end
  end
end
