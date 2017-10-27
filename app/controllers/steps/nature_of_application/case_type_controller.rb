module Steps
  module NatureOfApplication
    class CaseTypeController < Steps::NatureOfApplicationStepController
      include StartingPointStep

      def edit
        @form_object = CaseTypeForm.new(
          c100_application: current_c100_application,
          case_type: current_c100_application.case_type
        )
      end

      def update
        update_and_advance(CaseTypeForm)
      end

      def case_type_kickout; end
    end
  end
end
