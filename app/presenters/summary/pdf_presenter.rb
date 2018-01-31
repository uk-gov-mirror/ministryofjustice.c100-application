module Summary
  class PdfPresenter
    attr_reader :c100_application

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def sections
      [
        c100_form_sections,
        children_form_sections,
        miam_sections,
        application_reasons_sections,
        urgent_and_without_notice_sections,
        international_element_sections,
        litigation_capacity_sections,
        applicants_section,
        respondents_section,
      ].flatten.select(&:show?)
    end

    def pdf_params
      { pdf: pdf_filename, footer: { right: '[page]' } }
    end

    private

    def pdf_filename
      'c100_application'.freeze # TODO: to be decided
    end

    def c100_form_sections
      [
        Sections::FormHeader.new(c100_application, name: :c100_form),
        Sections::HelpWithFees.new(c100_application),
        Sections::ApplicantRespondent.new(c100_application),
        Sections::NatureOfApplication.new(c100_application),
        Sections::RiskConcerns.new(c100_application),
        Sections::AdditionalInformation.new(c100_application)
      ]
    end

    def children_form_sections
      [
        Sections::SectionHeader.new(c100_application, name: :children),
        Sections::ChildrenDetails.new(c100_application),
        Sections::ChildrenRelationships.new(c100_application)
      ]
    end

    def miam_sections
      [
        Sections::SectionHeader.new(c100_application, name: :miam_requirement),
        Sections::MiamRequirement.new(c100_application),
        # TODO: exemptions (section 3)
        Sections::SectionHeader.new(c100_application, name: :mediator_certification),
        Sections::MediatorCertification.new(c100_application),
      ]
    end

    def application_reasons_sections
      [
        Sections::SectionHeader.new(c100_application, name: :application_reasons),
        Sections::ApplicationReasons.new(c100_application),
      ]
    end

    def urgent_and_without_notice_sections
      [
        Sections::SectionHeader.new(c100_application, name: :urgent_and_without_notice),
        Sections::UrgentHearing.new(c100_application),
        Sections::WithoutNoticeHearing.new(c100_application),
      ]
    end

    def international_element_sections
      [
        Sections::SectionHeader.new(c100_application, name: :international_element),
        Sections::InternationalElement.new(c100_application)
      ]
    end

    def litigation_capacity_sections
      [
        Sections::SectionHeader.new(c100_application, name: :litigation_capacity),
        Sections::LitigationCapacity.new(c100_application),
      ]
    end

    def applicants_section
      [
        Sections::SectionHeader.new(c100_application, name: :applicants_details),
        Sections::ApplicantsDetails.new(c100_application),
      ]
    end

    def respondents_section
      [
        Sections::SectionHeader.new(c100_application, name: :respondents_details),
        Sections::RespondentsDetails.new(c100_application),
      ]
    end
  end
end
