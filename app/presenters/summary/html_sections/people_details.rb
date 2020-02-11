module Summary
  module HtmlSections
    class PeopleDetails < Sections::BaseSectionPresenter
      # :nocov:
      def record_collection
        raise 'must be implemented in subclasses'
      end

      def names_path
        raise 'must be implemented in subclasses'
      end

      def personal_details_path(*)
        raise 'must be implemented in subclasses'
      end

      def contact_details_path(*)
        raise 'must be implemented in subclasses'
      end

      def address_details_path(*)
        raise 'must be implemented in subclasses'
      end

      def child_relationship_path(*)
        raise 'must be implemented in subclasses'
      end
      # :nocov:

      def answers
        record_collection.map.with_index(1) do |person, index|
          [
            Separator.new("#{name}_index_title", index: index),
            FreeTextAnswer.new(:person_full_name, person.full_name, change_path: names_path),
            person_personal_details_answers_group(person),
            person_address_details_answers_group(person),
            person_contact_details_answers_group(person),
            children_relationships(person),
          ].compact
        end.flatten.select(&:show?)
      end

      private

      def personal_details_questions(person)
        [
          previous_name_answer(person),
          Answer.new(:person_sex, person.gender),
          DateAnswer.new(:person_dob, person.dob),
          FreeTextAnswer.new(:person_age_estimate, person.age_estimate), # This shows only if a value is present
          FreeTextAnswer.new(:person_birthplace, person.birthplace),
        ]
      end

      def contact_details_questions(person)
        [
          FreeTextAnswer.new(:person_email, person.email),
          FreeTextAnswer.new(:person_home_phone, person.home_phone),
          FreeTextAnswer.new(:person_mobile_phone, person.mobile_phone),
          Answer.new(:person_voicemail_consent, person.voicemail_consent), # This shows only if a value is present
        ]
      end

      def address_details_questions(person)
        [
          FreeTextAnswer.new(:person_address, person.full_address, show: true),
          Answer.new(:person_residence_requirement_met, person.residence_requirement_met),
          FreeTextAnswer.new(:person_residence_history, person.residence_history)
        ]
      end

      def previous_name_answer(person)
        if person.has_previous_name.eql?(GenericYesNo::YES.to_s)
          FreeTextAnswer.new(:person_previous_name, person.previous_name)
        else
          Answer.new(:person_previous_name, person.has_previous_name)
        end
      end

      def person_personal_details_answers_group(person)
        AnswersGroup.new(
          :person_personal_details,
          personal_details_questions(person),
          change_path: personal_details_path(person)
        )
      end

      def person_address_details_answers_group(person)
        AnswersGroup.new(
          :person_address_details,
          address_details_questions(person),
          change_path: address_details_path(person)
        )
      end

      def person_contact_details_answers_group(person)
        return unless contact_details_path(person)

        AnswersGroup.new(
          :person_contact_details,
          contact_details_questions(person),
          change_path: contact_details_path(person)
        )
      end

      def children_relationships(person)
        person.relationships.map do |rel|
          [
            Answer.new(
              :relationship_to_child,
              (rel.relation unless rel.relation.eql?(Relation::OTHER.to_s)),
              change_path: child_relationship_path(person, rel.minor),
              i18n_opts: {child_name: rel.minor.full_name}
            ),
            FreeTextAnswer.new(
              :relationship_to_child,
              rel.relation_other_value,
              change_path: child_relationship_path(person, rel.minor),
              i18n_opts: {child_name: rel.minor.full_name}
            ), # The free text value only shows when the relation is `other`
          ]
        end.flatten
      end
    end
  end
end
