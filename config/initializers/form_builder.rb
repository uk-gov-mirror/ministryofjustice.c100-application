# New design system (`govuk_design_system_formbuilder`)
#
# For now we use this in an ad hoc basis specifying it as an argument to form_for
# Once we've migrated all forms, we can set it globally here
#
# ActionView::Base.default_form_builder = GOVUKDesignSystemFormBuilder::FormBuilder

# Old design system (`govuk_elements_form_builder`)
ActionView::Base.default_form_builder = GovukElementsFormBuilder::FormBuilder

GOVUKDesignSystemFormBuilder.configure do |config|
  config.default_legend_tag  = 'h1'
  config.default_legend_size = 'xl'
end

# We must maintain backwards compatibility until all forms are migrated
GovukElementsFormBuilder::FormBuilder.class_eval do
  include CustomFormHelpers
end

GOVUKDesignSystemFormBuilder::FormBuilder.class_eval do
  include CustomFormHelpersV2
end
