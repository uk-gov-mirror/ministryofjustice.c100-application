module Summary
  module HtmlSections
    class ApplicationReasons < Sections::BaseSectionPresenter
      def name
        :application_reasons
      end

      def answers # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        [
          Answer.new(
            :permission_sought,
            c100.permission_sought,
            change_path: edit_steps_application_permission_sought_path
          ),
          FreeTextAnswer.new(
            :permission_details,
            c100.permission_details,
            change_path: edit_steps_application_permission_details_path
          ),
          FreeTextAnswer.new(
            :application_details,
            c100.application_details,
            change_path: edit_steps_application_details_path
          ),
          AnswersGroup.new(
            :existing_court_order,
            existing_court_order_questions,
            change_path: edit_steps_application_existing_court_order_path
          ),
          Answer.new(
            :existing_court_order_uploadable,
            c100.existing_court_order_uploadable,
            change_path: edit_steps_application_existing_court_order_uploadable_path
          ),
          FileAnswer.new(:existing_court_order_upload,
                         Uploader.get_file(
                           collection_ref: c100.files_collection_ref,
                           document_key: :existing_court_order
                         ).try(:name),
                         change_path: edit_steps_application_existing_court_order_upload_path)
        ].select(&:show?)
      end # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      private

      def existing_court_order_questions
        [
          FreeTextAnswer.new(
            :existing_court_order,
            c100.existing_court_order.try(:capitalize),
          ),
          FreeTextAnswer.new(
            :court_order_case_number,
            c100.court_order_case_number,
          ),
          FreeTextAnswer.new(
            :court_order_expiry_date,
            c100.court_order_expiry_date,
          ),
        ]
      end
    end
  end
end
