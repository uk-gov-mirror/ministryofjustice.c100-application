module Steps
  module Children
    class NamesForm < BaseForm
      attribute :names_attributes, Hash
      attribute :new_name, StrippedString

      validates_presence_of :new_name, if: :first_name?

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        create_new_child_with_name
        update_existing_children_names

        true
      end

      def create_new_child_with_name
        record_collection.create(name: new_name) unless new_name.blank?
      end

      def update_existing_children_names
        names_attributes.each_value do |attrs|
          next if attrs.fetch('name').blank?
          record_collection.update(attrs.fetch('id'), attrs)
        end
      end

      def first_name?
        return if c100_application.nil?
        record_collection.empty?
      end

      def record_collection
        @_record_collection ||= c100_application.children
      end
    end
  end
end
