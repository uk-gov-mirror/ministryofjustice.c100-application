module Steps
  module MiamExemptions
    class DomesticForm < BaseForm
      include MiamExemptionsForm

      setup_attributes_for DomesticExemptions, group_name: :domestic
    end
  end
end
