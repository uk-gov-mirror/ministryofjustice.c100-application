module Steps
  module MiamExemptions
    class DomesticForm < ExemptionsBaseForm
      setup_form_attributes_for(
        DomesticExemptions
      )

      def group_name
        :domestic
      end
    end
  end
end
