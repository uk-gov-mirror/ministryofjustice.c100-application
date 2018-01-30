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
          Answer.new(:miam_certification_details,        c100.miam_certification, default: GenericYesNo::NO),
          FreeTextAnswer.new(:miam_certification_number, c100.miam_certification_number),
          # TODO: we are missing some bits of information here (family mediation service name & sole trader name)
          DateAnswer.new(:miam_certification_date,       c100.miam_certification_date),
        ].select(&:show?)
      end
    end
  end
end
