module Steps
  module AbuseConcerns
    class PreviousProceedingsForm < BaseForm
      attribute :children_previous_proceedings, YesNo

      validates_inclusion_of :children_previous_proceedings, in: GenericYesNo.values

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        c100_application.update(
          children_previous_proceedings: children_previous_proceedings
        )
      end
    end
  end
end
