module Steps
  module MiamExemptions
    class ExemptionsBaseForm < BaseForm
      def self.setup_form_attributes_for(value_object)
        include HasOneAssociationForm
        has_one_association :miam_exemption

        attributes value_object.values, Boolean

        # We override the getter methods for each of the exemption attributes so we
        # can retrieve their state (checked/unchecked) from the DB array column.
        attribute_names.each do |name|
          define_method(name) { record_to_persist[group_name].include?(name.to_s) }
        end
      end

      # :nocov:
      def group_name
        raise 'implement in subclasses'
      end
      # :nocov:

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record_to_persist.update(
          group_name => selected_options
        )
      end
    end
  end
end
