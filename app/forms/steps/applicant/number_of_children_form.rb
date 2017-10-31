module Steps
  module Applicant
    class NumberOfChildrenForm < BaseForm
      attribute :number_of_children, Integer

      validates_presence_of :number_of_children

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          number_of_children: number_of_children
        )
      end
    end
  end
end
