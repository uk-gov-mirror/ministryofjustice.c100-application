module Steps
  module MiamExemptions
    class DomesticForm < BaseForm
      include MiamExemptionsCheckBoxesForm
      setup_attributes_for DomesticExemptions, attribute_name: :domestic
    end
  end
end
