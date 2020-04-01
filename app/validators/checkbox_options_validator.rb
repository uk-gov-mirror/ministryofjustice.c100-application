class CheckboxOptionsValidator < ActiveModel::EachValidator
  def initialize(options)
    super
    @_valid_values = options.fetch(:valid_values)
  end

  def validate_each(record, attribute, value)
    return unless value.is_a?(Array)

    record.errors.add(attribute, :invalid) unless valid_values?(value)
  end

  private

  def valid_values?(selected_options)
    selected_options.all? { |value| @_valid_values.include?(value) }
  end
end
