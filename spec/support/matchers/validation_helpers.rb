module ValidationHelpers
  private

  def check_errors(object, attribute, error)
    !object.valid?(validation_context)
    object.errors.added?(attribute, error)
  end

  def errors_for(attribute, object)
    object.errors.details[attribute].map { |h| h[:error] }.compact
  end
end
