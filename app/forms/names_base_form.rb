class NamesBaseForm < BaseForm
  attribute :names_attributes, Hash
  attribute :new_name, StrippedString

  validates_presence_of :new_name, if: :first_record?

  def split_names?
    false
  end

  private

  def persist!
    raise C100ApplicationNotFound unless c100_application

    create_new_record
    update_existing_record

    true
  end

  def create_new_record
    return if new_name.blank?
    record_collection.create(full_name: new_name)
  end

  def update_existing_record
    names_attributes.each_value do |attrs|
      next if attrs.fetch('full_name').blank?
      record_collection.update(attrs.fetch('id'), attrs)
    end
  end

  def first_record?
    return if c100_application.nil?
    record_collection.empty?
  end

  # :nocov:
  def record_collection
    raise 'implement in subclasses'
  end
  # :nocov:
end
