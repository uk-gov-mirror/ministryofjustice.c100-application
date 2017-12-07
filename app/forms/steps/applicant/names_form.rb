module Steps
  module Applicant
    class NamesForm < BaseForm
      attribute :names_attributes, Hash
      attribute :new_name, StrippedString

      validates_presence_of :new_name, if: :first_name?

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        create_new_record
        update_existing_record

        true
      end

      def create_new_record
        record_collection.create(full_name: new_name) unless new_name.blank?
      end

      def update_existing_record
        names_attributes.each_value do |attrs|
          next if attrs.fetch('full_name').blank?
          record_collection.update(attrs.fetch('id'), attrs)
        end
      end

      def first_name?
        return if c100_application.nil?
        record_collection.empty?
      end

      def record_collection
        @_record_collection ||= c100_application.applicants
      end
    end
  end
end
