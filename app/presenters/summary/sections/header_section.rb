module Summary
  module Sections
    class HeaderSection < BaseSectionPresenter
      def to_partial_path
        'shared/header'
      end

      def show?
        true
      end
    end
  end
end
