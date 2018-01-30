module Summary
  class PdfPresenter
    attr_reader :c100_application

    def initialize(c100_application)
      @c100_application = c100_application
    end

    # rubocop:disable Metrics/AbcSize
    def sections
      [
        Sections::FormHeader.new(c100_application, name: :c100_form),
        Sections::HelpWithFees.new(c100_application),
        Sections::ApplicantRespondent.new(c100_application),
        Sections::NatureOfApplication.new(c100_application),
        Sections::RiskConcerns.new(c100_application),
        Sections::AdditionalInformation.new(c100_application),
        Sections::SectionHeader.new(c100_application, name: :children),
        Sections::ChildrenDetails.new(c100_application),
        Sections::ChildrenRelationships.new(c100_application),
        Sections::SectionHeader.new(c100_application, name: :miam_requirement),
        Sections::MiamRequirement.new(c100_application),
        Sections::SectionHeader.new(c100_application, name: :mediator_certification),
        Sections::MediatorCertification.new(c100_application),
        Sections::SectionHeader.new(c100_application, name: :application_reasons),
        Sections::ApplicationReasons.new(c100_application),
        Sections::SectionHeader.new(c100_application, name: :urgent_and_without_notice),
        Sections::UrgentHearing.new(c100_application),
      ].select(&:show?)
    end
    # rubocop:enable Metrics/AbcSize

    def pdf_params
      { pdf: pdf_filename, footer: { right: '[page]' } }
    end

    private

    def pdf_filename
      'c100_application'.freeze # TODO: to be decided
    end
  end
end
