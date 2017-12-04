module Steps
  module Children
    class OtherChildrenController < Steps::ChildrenStepController
      def edit
        @form_object = OtherChildrenForm.new(
          c100_application: current_c100_application,
          other_children: current_c100_application.other_children
        )
      end

      def update
        update_and_advance(OtherChildrenForm)
      end
    end
  end
end
