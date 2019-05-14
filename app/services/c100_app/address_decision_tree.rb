module C100App
  class AddressDecisionTree < BaseDecisionTree
    include Rails.application.routes.url_helpers

    def destination
      return next_step if next_step

      case step_name
      when :postcode_lookup
        # TODO: introduce intermediate results step. For now we jump to the address fields
        after_postcode_lookup
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_postcode_lookup
      # TODO: this is a horrible, terrible workaround for the fact we were not careful
      # when we designed the URLs for people of kind `OtherParty` and we pluralised them,
      # against the convention, now making it very difficult to work with them.
      #
      # We must fix it soon but maintaining backwards-compatibility with saved applications.
      #
      if record.instance_of?(OtherParty)
        # Will return:
        #   /steps/other_parties/address_details/:uuid
        polymorphic_path([:steps, :other_parties, :address_details], id: record)
      else
        # Will return:
        #   /steps/applicant/address_details/:uuid
        #   /steps/respondent/address_details/:uuid
        polymorphic_path([:steps, record, :address_details])
      end
    end
  end
end
