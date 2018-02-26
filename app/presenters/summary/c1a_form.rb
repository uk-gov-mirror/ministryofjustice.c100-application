module Summary
  class C1aForm < BasePdfForm
    def sections
      [
        Sections::FormHeader.new(c100_application, name: :c1a_form),
        Sections::C1aCourtDetails.new(c100_application),
        *people_details,
        *abuse_summary,
        *abuse_details,
      ].flatten.select(&:show?)
    end

    # Note: if the service gets ever translated to Welsh, then we will need
    # a translated C1A page 9 and a bit of code to know which file to use.
    def raw_file_path
      'app/assets/docs/c1a_page9.en.pdf'
    end

    private

    def people_details
      [
        Sections::SectionHeader.new(c100_application, name: :c1a_applicants_details),
        Sections::C1aApplicantDetails.new(c100_application),
        Sections::C1aChildrenDetails.new(c100_application),
        Sections::C1aSolicitorDetails.new(c100_application),
      ]
    end

    def abuse_summary
      [
        Sections::SectionHeader.new(c100_application, name: :c1a_abuse_details),
        Sections::C1aChildrenAbuseSummary.new(c100_application),
        Sections::C1aApplicantAbuseSummary.new(c100_application),
        Sections::C1aCourtOrders.new(c100_application),
      ]
    end

    def abuse_details
      [
        Sections::C1aConcernsSubstance.new(c100_application),
        Sections::C1aChildrenAbuseDetails.new(c100_application),
        Sections::C1aApplicantAbuseDetails.new(c100_application),
      ]
    end
  end
end
