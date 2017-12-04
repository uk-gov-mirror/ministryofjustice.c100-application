module Steps
  module OtherChildren
    class NamesController < Steps::OtherChildrenStepController
      include CrudStep

      def edit
        @form_object = NamesForm.new(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(
          NamesForm,
          as: params.fetch(:button, :names_finished)
        )
      end

      def destroy
        current_record.destroy
        redirect_to action: :edit, id: nil
      end

      private

      def additional_permitted_params
        [names_attributes: [:id, :full_name]]
      end

      def record_collection
        @_record_collection ||= current_c100_application.children.secondary
      end
    end
  end
end
