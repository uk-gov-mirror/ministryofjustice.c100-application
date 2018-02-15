module Steps
  module MiamExemptions
    class AdrForm < BaseForm
      include MiamExemptionsForm

      setup_attributes_for AdrExemptions, group_name: :adr
    end
  end
end
