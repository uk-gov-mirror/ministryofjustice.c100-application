module Steps
  module Application
    class LitigationCapacityForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :reduced_litigation_capacity,
                       reset_when_no: [
                         :participation_capacity_details,
                         :participation_referral_or_assessment_details,
                         :participation_other_factors_details
                       ]
    end
  end
end
