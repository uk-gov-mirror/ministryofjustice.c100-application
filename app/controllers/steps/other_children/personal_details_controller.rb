module Steps
  module OtherChildren
    class PersonalDetailsController < Steps::OtherChildrenStepController
      include CrudStep

      def edit
        @form_object = PersonalDetailsForm.build(
          current_record, c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(
          PersonalDetailsForm,
          record: current_record,
          as: :personal_details
        )
      end

      private

      def record_collection
        @_record_collection ||= current_c100_application.other_children
      end
    end
  end
end
