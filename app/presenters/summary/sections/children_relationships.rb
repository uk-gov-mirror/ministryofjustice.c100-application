module Summary
  module Sections
    class ChildrenRelationships < BaseSectionPresenter
      def name
        :children_relationships
      end

      def answers
        [
          FreeTextAnswer.new(
            :applicants_relationships,
            RelationshipsPresenter.new(c100_application).relationship_to_children(c100.applicants)
          ),
          *affirmative_permission_questions,
          FreeTextAnswer.new(
            :respondents_relationships,
            RelationshipsPresenter.new(c100_application).relationship_to_children(c100.respondents)
          ),
          FreeTextAnswer.new(
            :other_parties_relationships,
            RelationshipsPresenter.new(c100_application).relationship_to_children(c100.other_parties)
          ),
          Partial.row_blank_space,
        ].select(&:show?)
      end

      private

      # Only loop through relationships that entered the non-parents journey,
      # i.e. those having at least the first of those attributes as not `nil`.
      #
      # This saves us from having to iterate through all the relationships, as
      # many of those will be respondents, other parties, or other children.
      #
      def affirmative_permission_questions
        answers = permission_relationships.map do |relationship|
          permission_attributes.map do |attr|
            answer = relationship.try!(attr)

            next if answer.eql?(GenericYesNo::NO.to_s)

            # Break the loop and return the first `yes` answer found
            break Answer.new(
              "child_permission_#{attr}", answer,
              i18n_opts: { applicant_name: relationship.person.full_name, child_name: relationship.minor.full_name }
            )
          end
        end.flatten.compact

        # If there are answers, add a separation between these and the
        # next group (respondents_relationships) to not look so cramped.
        answers.append(Partial.row_blank_space) if answers.any?
      end

      def permission_relationships
        @_permission_relationships ||= c100.relationships.with_permission_data
      end

      def permission_attributes
        Relationship::PERMISSION_ATTRIBUTES
      end
    end
  end
end
