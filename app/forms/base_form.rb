class BaseForm
  class C100ApplicationNotFound < RuntimeError; end

  include Virtus.model
  include ActiveModel::Validations

  attr_accessor :c100_application
  attr_accessor :record_id

  def save
    if valid?
      persist!
    else
      false
    end
  end

  def to_key
    # Intentionally returns nil so the form builder picks up _only_
    # the class name to generate the HTML attributes.
    nil
  end

  def persisted?
    false
  end

  private

  # :nocov:
  def persist!
    raise 'Subclasses of BaseForm need to implement #persist!'
  end
  # :nocov:
end
