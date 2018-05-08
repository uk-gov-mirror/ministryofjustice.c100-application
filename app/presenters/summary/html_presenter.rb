module Summary
  class HtmlPresenter
    attr_reader :c100_application

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def sections
      [
        HtmlSections::ChildProtectionCases.new(c100_application),
        HtmlSections::MiamRequirement.new(c100_application),
        HtmlSections::MiamExemptions.new(c100_application),
        *safety_and_abuse_questions,
        HtmlSections::NatureOfApplication.new(c100_application),
        HtmlSections::Alternatives.new(c100_application),
        *children_sections,
        *people_sections,
        other_court_cases,
      ].flatten.select(&:show?)
    end

    private

    def safety_and_abuse_questions
      [
        HtmlSections::SafetyConcerns.new(c100_application),
        HtmlSections::Abduction.new(c100_application),
        HtmlSections::ChildrenAbuseDetails.new(c100_application),
        HtmlSections::ApplicantAbuseDetails.new(c100_application),
        HtmlSections::CourtOrders.new(c100_application),
        HtmlSections::SafetyContact.new(c100_application),
      ]
    end

    def children_sections
      [
        HtmlSections::ChildrenDetails.new(c100_application),
        HtmlSections::ChildrenFurtherInformation.new(c100_application),
        HtmlSections::OtherChildrenDetails.new(c100_application),
      ]
    end

    def people_sections
      [
        HtmlSections::ApplicantsDetails.new(c100_application),
        HtmlSections::RespondentsDetails.new(c100_application),
        HtmlSections::OtherPartiesDetails.new(c100_application),
      ]
    end

    def other_court_cases
      [
        HtmlSections::OtherCourtCases.new(c100_application),
      ]
    end
  end
end
