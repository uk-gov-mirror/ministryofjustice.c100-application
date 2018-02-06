module Summary
  module Sections
    class MediatorCertification < BaseSectionPresenter
      def name
        :mediator_certification
      end

      def show_header?
        false
      end

      def answers
        [
          Answer.new(:miam_certification_details, c100.miam_certification, default: GenericYesNo::NO),
          FreeTextAnswer.new(:miam_certification_number, c100.miam_certification_number),
          FreeTextAnswer.new(:miam_certification_service_name, c100.miam_certification_service_name),
          FreeTextAnswer.new(:miam_certification_sole_trader_name, c100.miam_certification_sole_trader_name),
          DateAnswer.new(:miam_certification_date, c100.miam_certification_date),
        ].select(&:show?)
      end
    end
  end
end
