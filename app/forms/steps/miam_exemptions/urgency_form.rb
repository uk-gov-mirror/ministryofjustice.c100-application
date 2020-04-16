module Steps
  module MiamExemptions
    class UrgencyForm < BaseForm
      include MiamExemptionsCheckBoxesForm
      setup_attributes_for UrgencyExemptions, attribute_name: :urgency
    end
  end
end
