module Steps
  module AttendingCourt
    class LanguageForm < BaseForm
      include HasOneAssociationForm

      has_one_association :court_arrangement

      attribute :language_interpreter, Boolean
      attribute :language_interpreter_details, String

      attribute :sign_language_interpreter, Boolean
      attribute :sign_language_interpreter_details, String

      validates_presence_of :language_interpreter_details, if: :language_interpreter?
      validates_presence_of :sign_language_interpreter_details, if: :sign_language_interpreter?

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          attributes_map.merge(
            language_interpreter_details: (language_interpreter_details if language_interpreter?),
            sign_language_interpreter_details: (sign_language_interpreter_details if sign_language_interpreter?),
          )
        )
      end
    end
  end
end
