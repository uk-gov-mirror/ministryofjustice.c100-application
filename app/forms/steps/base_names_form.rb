module Steps
  class BaseNamesForm < BaseForm
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
      record_collection.create(name_attribute => new_name) unless new_name.blank?
    end

    def update_existing_record
      names_attributes.each_value do |attrs|
        next if attrs.fetch(name_attribute.to_s).blank?
        record_collection.update(attrs.fetch('id'), attrs)
      end
    end

    def first_name?
      return if c100_application.nil?
      record_collection.empty?
    end

    # The default attribute for storing the name in the People table is `full_name`,
    # but can be customised in subclasses, for example for Children we ask for the 'short' name.
    def name_attribute
      :full_name
    end

    # :nocov:
    def record_collection
      raise 'implement in subclasses'
    end
    # :nocov:
  end
end
