module Steps
  module Children
    class PersonalDetailsController < Steps::ChildrenStepController
      include CrudStep

      def edit
        @form_object = PersonalDetailsForm.build(
          current_record, c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(
          PersonalDetailsForm,
          record_id: current_record.id,
          as: params.fetch(:button, :children_finished)
        )
      end

      private

      def record_collection
        @_record_collection ||= current_c100_application.children
      end
    end
  end
end
