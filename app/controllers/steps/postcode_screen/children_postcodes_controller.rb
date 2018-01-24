module Steps
  module PostcodeScreen
    class ChildrenPostcodesController < Steps::PostcodeScreenStepController
      def edit
        @form_object = ChildrenPostcodesForm.new(
          c100_application: current_c100_application,
          children_postcodes: current_c100_application.children_postcodes
        )
      end

      def update
        update_and_advance(ChildrenPostcodesForm)
      end
    end
  end
end
