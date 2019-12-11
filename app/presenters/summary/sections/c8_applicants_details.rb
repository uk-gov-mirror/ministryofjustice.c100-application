module Summary
  module Sections
    class C8ApplicantsDetails < PeopleDetails
      def name
        :c8_applicants_details
      end

      def show_header?
        true
      end

      def record_collection
        c100.applicants
      end

      # Not using the superclass `PeopleDetails#answers` because, in the case of
      # applicants, most of the information is already disclosed in the C100, and here
      # we just need to show the confidential details. The superclass will show all.
      #
      def answers
        record_collection.map.with_index(1) do |person, index|
          [
            Separator.new("#{name}_index_title", index: index),
            FreeTextAnswer.new(:person_full_name, person.full_name),
            FreeTextAnswer.new(:person_address, person.full_address),
            FreeTextAnswer.new(:person_residence_history, person.residence_history),
            FreeTextAnswer.new(:person_email, person.email),
            FreeTextAnswer.new(:person_home_phone, person.home_phone),
            FreeTextAnswer.new(:person_mobile_phone, person.mobile_phone),
            Answer.new(:person_voicemail_consent, person.voicemail_consent),
            Partial.row_blank_space,
          ]
        end.flatten.select(&:show?)
      end
    end
  end
end
