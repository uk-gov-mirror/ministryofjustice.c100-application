module Steps
  module Shared
    class UnderAgeForm < BaseForm
      # This form does nothing really, but we use it for the interstitials 'under 18 years'
      # warning pages, which are complex in the sense we need to keep track of the current
      # applicant and, for the following page, the child to ask for their relationship.

      def persist!
        raise C100ApplicationNotFound unless c100_application
        true
      end
    end
  end
end
