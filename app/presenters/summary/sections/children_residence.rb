module Summary
  module Sections
    class ChildrenResidence < BaseSectionPresenter
      def name
        :children_residence
      end

      def show_header?
        false
      end

      def answers
        [
          FreeTextAnswer.new(:children_residence, children_residence),
        ].select(&:show?)
      end

      private

      def children_residence
        ChildResidence.where(child: c100.children).map do |residence|
          residence_full_names(residence)
        end.join('; ')
      end

      # TODO: we might need to separate which child lives with each of the parties
      # For now it is not clear in the PDF mockup, so this is just a simple solution.
      # Also we will need to handle somehow the C8 for `other parties`. Awaiting design.
      # :nocov:
      def residence_full_names(residence)
        names = c100.people.where(id: residence.person_ids).pluck(:full_name)
        names << residence.other_full_name if residence.other?
        names
      end
      # :nocov:
    end
  end
end
