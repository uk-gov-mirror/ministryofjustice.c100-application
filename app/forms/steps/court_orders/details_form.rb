module Steps
  module CourtOrders
    class DetailsForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      ORDER_NAMES = [
        :non_molestation,
        :occupation,
        :forced_marriage_protection,
        :restraining,
        :injunctive,
        :undertaking
      ].freeze

      NON_MOLESTATION_ATTRIBUTES = {
        non_molestation: String,
        non_molestation_issue_date: Date,
        non_molestation_length: String,
        non_molestation_is_current: String,
        non_molestation_court_name: String
      }.freeze.each { |name, type| attribute(name, type) }

      OCCUPATION_ATTRIBUTES = {
        occupation: String,
        occupation_issue_date: Date,
        occupation_length: String,
        occupation_is_current: String,
        occupation_court_name: String
      }.freeze.each { |name, type| attribute(name, type) }

      FORCED_MARRIAGE_PROTECTION_ATTRIBUTES = {
        forced_marriage_protection: String,
        forced_marriage_protection_issue_date: Date,
        forced_marriage_protection_length: String,
        forced_marriage_protection_is_current: String,
        forced_marriage_protection_court_name: String
      }.freeze.each { |name, type| attribute(name, type) }

      RESTRAINING_ATTRIBUTES = {
        restraining: String,
        restraining_issue_date: Date,
        restraining_length: String,
        restraining_is_current: String,
        restraining_court_name: String
      }.freeze.each { |name, type| attribute(name, type) }

      INJUNCTIVE_ATTRIBUTES = {
        injunctive: String,
        injunctive_issue_date: Date,
        injunctive_length: String,
        injunctive_is_current: String,
        injunctive_court_name: String
      }.freeze.each { |name, type| attribute(name, type) }

      UNDERTAKING_ATTRIBUTES = {
        undertaking: String,
        undertaking_issue_date: Date,
        undertaking_length: String,
        undertaking_is_current: String,
        undertaking_court_name: String
      }.freeze.each { |name, type| attribute(name, type) }

      acts_as_gov_uk_date *(ORDER_NAMES.map{ |att| "#{att}_issue_date" })

      validates_inclusion_of *ORDER_NAMES, in: GenericYesNo.string_values

      validates_presence_of *NON_MOLESTATION_ATTRIBUTES.keys,            if: ->{ yes?(non_molestation) }
      validates_presence_of *OCCUPATION_ATTRIBUTES.keys,                 if: ->{ yes?(occupation) }
      validates_presence_of *FORCED_MARRIAGE_PROTECTION_ATTRIBUTES.keys, if: ->{ yes?(forced_marriage_protection) }
      validates_presence_of *RESTRAINING_ATTRIBUTES.keys,                if: ->{ yes?(restraining) }
      validates_presence_of *INJUNCTIVE_ATTRIBUTES.keys,                 if: ->{ yes?(injunctive) }
      validates_presence_of *UNDERTAKING_ATTRIBUTES.keys,                if: ->{ yes?(undertaking) }

      private

      def yes?(order)
        order.eql?(GenericYesNo::YES.to_s)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        orders_record = c100_application.court_order || c100_application.build_court_order
        orders_record.update(
          attributes_map
        )
      end
    end
  end
end
