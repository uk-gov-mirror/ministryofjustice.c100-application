module Steps
  module NatureOfApplication
    class CaseTypeForm < BaseForm
      attribute :case_type, String

      def self.choices
        [
          CaseType::CHILD_ARRANGEMENTS,
          CaseType::PROHIBITED_STEPS,
          CaseType::SPECIFIC_ISSUE
        ].map(&:to_s)
      end

      validates_inclusion_of :case_type, in: choices

      private

      def case_type_value
        CaseType.new(case_type)
      end

      def changed?
        !c100_application.case_type.eql?(case_type_value)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application
        return true unless changed?

        c100_application.update(
          case_type: case_type_value
        )
      end
    end
  end
end
