module Summary
  module Sections
    class StatementOfTruth < BaseSectionPresenter
      def name
        :statement_of_truth
      end

      def show_header?
        false
      end

      def answers
        [
          Partial.new(:statement_of_truth, applicant_name),
        ]
      end

      private

      def applicant_name
        c100.applicants.first&.full_name
      end
    end
  end
end
