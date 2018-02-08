module Summary
  class C8Form < BasePdfForm
    def sections
      [
        Sections::FormHeader.new(c100_application, name: :c8_form),
        Sections::C8CourtDetails.new(c100_application),
      ].flatten.select(&:show?)
    end
  end
end
