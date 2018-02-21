module Summary
  class C1aForm < BasePdfForm
    def sections
      [
        Sections::FormHeader.new(c100_application, name: :c1a_form),
        Sections::C1aCourtDetails.new(c100_application),
      ].flatten.select(&:show?)
    end
  end
end
