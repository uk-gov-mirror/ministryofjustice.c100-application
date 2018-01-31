module Summary
  module Sections
    class PeopleDetails < BaseSectionPresenter
      def show_header?
        false
      end

      # :nocov:
      def record_collection
        raise 'must be implemented in subclasses'
      end
      # :nocov:

      # rubocop:disable Metrics/AbcSize
      def answers
        record_collection.map.with_index(1) do |person, index|
          [
            Separator.new("#{name}_index_title", index: index),
            FreeTextAnswer.new(:person_full_name, person.full_name),
            previous_name_answer(person),
            Answer.new(:person_sex, person.gender),
            DateAnswer.new(:person_dob, person.dob),
            FreeTextAnswer.new(:person_birthplace, person.birthplace),
            FreeTextAnswer.new(:person_address, person.address),
            Answer.new(:person_residence_requirement_met, person.residence_requirement_met),
            FreeTextAnswer.new(:person_residence_history, person.residence_history),
            FreeTextAnswer.new(:person_home_phone, person.home_phone),
            FreeTextAnswer.new(:person_mobile_phone, person.mobile_phone),
            FreeTextAnswer.new(:person_email, person.email),
          ]
        end.flatten.select(&:show?)
      end
      # rubocop:enable Metrics/AbcSize

      private

      def previous_name_answer(person)
        if person.has_previous_name.eql?(GenericYesNo::YES.to_s)
          FreeTextAnswer.new(:person_previous_name, person.previous_name)
        else
          Answer.new(:person_previous_name, person.has_previous_name)
        end
      end
    end
  end
end
