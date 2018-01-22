class BaseForm
  class C100ApplicationNotFound < RuntimeError; end

  include Virtus.model
  include ActiveModel::Validations
  extend ActiveModel::Callbacks

  attr_accessor :c100_application
  attr_accessor :record

  # This will allow subclasses to define after_initialize callbacks
  # and is needed for some functionality to work, i.e. acts_as_gov_uk_date
  define_model_callbacks :initialize

  def initialize(*)
    run_callbacks(:initialize) { super }
  end

  # Initialize a new form object given an AR model, setting its attributes
  def self.build(record, c100_application: nil)
    attributes = attributes_map(record)

    attributes.merge!(
      c100_application: c100_application || record,
      record: record
    )

    new(attributes)
  end

  def save
    if valid?
      persist!
    else
      false
    end
  end

  # Add the ability to read/write attributes without calling their accessor methods.
  # Needed to behave more like an ActiveRecord model, where you can manipulate the
  # database attributes making use of `self[:attribute]`
  def [](attr_name)
    instance_variable_get("@#{attr_name}".to_sym)
  end

  def []=(attr_name, value)
    instance_variable_set("@#{attr_name}".to_sym, value)
  end

  # A shortcut to declaring multiple attributes of the same type
  def self.attributes(collection, type, opts = {})
    collection.each { |name| attribute(name, type, opts) }
  end

  # Iterates through all declared attributes in the form object, mapping its values
  def self.attributes_map(origin)
    attribute_set.map { |attr| [attr.name, origin[attr.name]] }.to_h
  end

  def attributes_map
    self.class.attributes_map(self)
  end

  def to_key
    # Intentionally returns nil so the form builder picks up _only_
    # the class name to generate the HTML attributes.
    nil
  end

  def persisted?
    false
  end

  def new_record?
    true
  end

  private

  def record_id
    record&.id
  end

  # When using concerns like `HasOneAssociationForm` or `SingleQuestionForm`, this ensures
  # a common interface to always have the correct record being updated in the `persist!` method.
  # The default is the main model, i.e. `c100_application` unless overridden by subclasses.
  def record_to_persist
    c100_application
  end

  # :nocov:
  def persist!
    raise 'Subclasses of BaseForm need to implement #persist!'
  end
  # :nocov:
end
