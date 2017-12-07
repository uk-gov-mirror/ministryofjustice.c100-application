module Steps
  module Children
    class NamesController < Steps::ChildrenStepController
      include CrudStep
      include NamesCrudStep

      private

      def form_class
        NamesForm
      end

      def record_collection
        @_record_collection ||= current_c100_application.children
      end
    end
  end
end
