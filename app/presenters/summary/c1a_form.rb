module Summary
  class C1aForm < BasePdfForm
    def sections
      [
        Sections::FormHeader.new(c100_application, name: :c1a_form),
        Sections::C1aCourtDetails.new(c100_application),
      ].flatten.select(&:show?)
    end

    # Note: if the service gets ever translated to Welsh, then we will need
    # a translated C1A page 9 and a bit of code to know which file to use.
    def raw_file_path
      'app/assets/docs/c1a_page9.en.pdf'
    end
  end
end
