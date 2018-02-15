module Steps
  module MiamExemptions
    class UrgencyForm < ExemptionsBaseForm
      setup_form_attributes_for(
        UrgencyExemptions
      )

      def group_name
        :urgency
      end
    end
  end
end
