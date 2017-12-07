module Steps
  module OtherChildren
    class NamesController < Steps::OtherChildrenStepController
      include CrudStep
      include NamesCrudStep

      private

      def form_class
        NamesForm
      end

      def record_collection
        @_record_collection ||= current_c100_application.other_children
      end
    end
  end
end
