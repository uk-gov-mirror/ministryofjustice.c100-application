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

      def children_relationships_path(*)
        raise 'must be implemented in subclasses that support relationships'
      end
      # :nocov:

      def answers
        record_collection.map.with_index(1) do |person, index|
          [
            Separator.new("#{name}_index_title", index: index),
            FreeTextAnswer.new(:person_full_name, person.full_name, change_path: names_path),
            AnswersGroup.new(
              :person_personal_details,
              personal_details_questions(person),
              change_path: personal_details_path(person)
            ),
            AnswersGroup.new(
              :person_contact_details,
              contact_details_questions(person),
              change_path: contact_details_path(person)
            ),
            children_relationships(person),
          ]
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
          FreeTextAnswer.new(:person_address, person.address, show: true),
          Answer.new(:person_residence_requirement_met, person.residence_requirement_met),
          FreeTextAnswer.new(:person_residence_history, person.residence_history),
          FreeTextAnswer.new(:person_home_phone, person.home_phone),
          FreeTextAnswer.new(:person_mobile_phone, person.mobile_phone),
          FreeTextAnswer.new(:person_email, person.email),
        ]
      end

      def previous_name_answer(person)
        if person.has_previous_name.eql?(GenericYesNo::YES.to_s)
          FreeTextAnswer.new(:person_previous_name, person.previous_name)
        else
          Answer.new(:person_previous_name, person.has_previous_name)
        end
      end

      def children_relationships(person)
        person.relationships.map do |rel|
          [
            Answer.new(
              :relationship_to_child,
              (rel.relation unless rel.relation.eql?(Relation::OTHER.to_s)),
              change_path: children_relationships_path(person, rel.minor),
              i18n_opts: {child_name: rel.minor.full_name}
            ),
            FreeTextAnswer.new(
              :relationship_to_child,
              rel.relation_other_value,
              change_path: children_relationships_path(person, rel.minor),
              i18n_opts: {child_name: rel.minor.full_name}
            ), # The free text value only shows when the relation is `other`
          ]
        end.flatten
      end
    end
  end
end
