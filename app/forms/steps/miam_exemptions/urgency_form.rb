module Steps
  module MiamExemptions
    class UrgencyForm < BaseForm
      include MiamExemptionsForm

      setup_attributes_for UrgencyExemptions, group_name: :urgency
    end
  end
end
