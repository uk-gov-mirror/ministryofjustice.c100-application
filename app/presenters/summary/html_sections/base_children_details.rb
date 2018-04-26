module Summary
  module HtmlSections
    class BaseChildrenDetails < Sections::BaseSectionPresenter
      protected

      # rubocop:disable Metrics/MethodLength
      def personal_details(child)
        [
          FreeTextAnswer.new(
            :child_full_name,
            child.full_name,
            change_path: edit_steps_children_names_path(child)
          ),
          DateAnswer.new(
            :child_dob,
            child.dob,
            change_path: edit_child_details_path(child, 'dob_dd')
          ),
          FreeTextAnswer.new(
            :child_age_estimate,
            child.age_estimate,
            change_path: edit_child_details_path(child, 'age_estimate')
          ),
          Answer.new(
            :child_sex,
            child.gender,
            change_path: edit_child_details_path(child, 'gender_female')
          ),
        ]
      end
      # rubocop:enable Metrics/MethodLength

      def relationships(child)
        [
          MultiAnswer.new(:child_applicants_relationship,  relation_to_child(child, c100.applicants), change_path: edit_relation_path(child, c100.applicants)),
          MultiAnswer.new(:child_respondents_relationship, relation_to_child(child, c100.respondents), change_path: edit_relation_path(child, c100.applicants)),
        ]
      end

      private

      def edit_relation_path(child, people)
        format("/steps/applicant/relationship/%<id>s/child/%<child_id>s",
               id: relationship(child, people).pluck(:id),
               child_id: child.id)
      end

      def edit_child_details_path(child, field_stub)
        edit_steps_children_personal_details_path(
          child,
          anchor: format('steps_children_personal_details_form_%<field_stub>s',
                         field_stub: field_stub)
        )
      end

      def relation_to_child(child, people)
        relationship(child, people).pluck(:relation)
      end

      def relationship(child, people)
        child.relationships.where(person: people)
      end
    end
  end
end
