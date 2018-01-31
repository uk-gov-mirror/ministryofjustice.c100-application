module Summary
  module Sections
    class ApplicantsDetails < BaseSectionPresenter
      def name
        :applicants_details
      end

      def show_header?
        false
      end

      # rubocop:disable Metrics/AbcSize
      def answers
        c100.applicants.map.with_index(1) do |applicant, index|
          [
            Separator.new(:applicant_index_title, index: index),
            FreeTextAnswer.new(:person_full_name, applicant.full_name),
            Answer.new(:person_has_previous_name, applicant.has_previous_name),
            Answer.new(:person_sex, applicant.gender),
            DateAnswer.new(:person_dob, applicant.dob),
            FreeTextAnswer.new(:person_birthplace, applicant.birthplace),
            FreeTextAnswer.new(:person_address, applicant.address),
            Answer.new(:person_residence_requirement_met, applicant.residence_requirement_met),
            FreeTextAnswer.new(:person_home_phone, applicant.home_phone),
            FreeTextAnswer.new(:person_mobile_phone, applicant.mobile_phone),
            FreeTextAnswer.new(:person_email, applicant.email),
          ]
        end.flatten.select(&:show?)
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
