module Steps
  module OtherChildren
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
        return if new_name.blank?

        record_collection.create(
          full_name: new_name,
          kind: ChildrenType::SECONDARY
        )
      end

      def update_existing_children_names
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
        @_record_collection ||= c100_application.children.secondary
      end
    end
  end
end
