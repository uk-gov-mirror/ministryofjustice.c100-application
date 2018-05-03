module Summary
  module HtmlSections
    class NatureOfApplication < Sections::BaseSectionPresenter
      def name
        :nature_of_application
      end

      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      def answers
        [
          MultiAnswer.new(:child_arrangements_orders,
                          petition.child_arrangements_orders,
                          change_path: edit_steps_petition_orders_path(
                            anchor: 'steps_petition_orders_form_group_child_arrangements_home'
                          )),
          MultiAnswer.new(:prohibited_steps_orders,
                          petition.prohibited_steps_orders,
                          change_path: edit_steps_petition_orders_path(
                            anchor: 'steps_petition_orders_form_group_prohibited_steps'
                          )),
          MultiAnswer.new(:specific_issues_orders,
                          petition.specific_issues_orders,
                          change_path: edit_steps_petition_orders_path(
                            anchor: 'steps_petition_orders_form_group_specific_issues'
                          )),
          FreeTextAnswer.new(:other_issue_details,
                             petition.other_issue_details,
                             change_path: edit_steps_petition_orders_path(
                               anchor: 'steps_petition_orders_form_other_issue'
                             )),
          AnswersGroup.new(
            :protection_orders,
            [
              Answer.new(:protection_orders, c100.protection_orders),
              FreeTextAnswer.new(:protection_orders_details, c100.protection_orders_details),
            ],
            change_path: edit_steps_petition_protection_path
          ),
        ].select(&:show?)
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

      private

      def petition
        @_petition ||= PetitionPresenter.new(c100)
      end
    end
  end
end
