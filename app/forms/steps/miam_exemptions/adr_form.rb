module Steps
  module MiamExemptions
    class AdrForm < BaseForm
      include MiamExemptionsCheckBoxesForm
      setup_attributes_for AdrExemptions, attribute_name: :adr
    end
  end
end
