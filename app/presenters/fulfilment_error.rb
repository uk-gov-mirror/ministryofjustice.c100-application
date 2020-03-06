class FulfilmentError
  attr_reader :attribute, :message, :error, :change_path

  def initialize(attribute, message:, error:, change_path:)
    @attribute = attribute
    @message = message
    @error = error
    @change_path = change_path
  end

  # Used by Rails to determine which partial to render.
  def to_partial_path
    'steps/application/check_your_answers/fulfilment_error'
  end
end
