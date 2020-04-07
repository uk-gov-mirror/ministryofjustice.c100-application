class CheckboxBoolean < Virtus::Attribute::Boolean
  #
  # Used to coerce checkboxes created with the new form builder
  # `govuk_design_system_formbuilder`.
  #
  # This is considered a legacy, backwards-compatible workaround and
  # once we finish migrating the application to the new design system
  # we should get back to any form object making use of this and
  # replace the checkbox attributes with a more standard way.
  #
  # The only thing it does is, as the attributes are sent wrapped in
  # an array, extract the (only) element inside and let the original
  # super class do the rest of the coercion.
  #
  def coerce(value)
    super(
      Array(value).first || false
    )
  end
end
