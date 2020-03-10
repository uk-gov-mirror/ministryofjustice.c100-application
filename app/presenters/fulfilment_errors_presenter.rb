class FulfilmentErrorsPresenter
  attr_writer :errors

  FulfilmentError = Struct.new(:attribute, :message, :error, :change_path, keyword_init: true)

  def initialize(c100_application)
    @errors = c100_application.errors
  end

  def errors
    @errors.map.with_index do |(attribute, message), index|
      FulfilmentError.new(
        attribute: attribute,
        message: message,
        error: details(attribute, index, :error),
        change_path: details(attribute, index, :change_path),
      )
    end
  end

  private

  def details(attribute, index, key)
    @errors.details[attribute][index][key]
  end
end
