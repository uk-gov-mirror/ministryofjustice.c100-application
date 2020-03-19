module ApplicationHelper
  # Render a form_for tag pointing to the update action of the current controller
  def step_form(record, options = {}, &block)
    opts = {
      url: { controller: controller.controller_path, action: :update },
      method: :put
    }.merge(options)

    # Support for appending optional css classes, maintaining the default one
    opts.merge!(
      html: { class: dom_class(record, :edit) }
    ) do |_key, old_value, new_value|
      { class: old_value.values | new_value.values }
    end

    form_for record, opts, &block
  end

  # Render a back link pointing to the user's previous step
  def step_header(path: nil)
    capture do
      render partial: 'layouts/step_header', locals: {
        path: path || controller.previous_step_path
      }
    end + error_summary(@form_object)
  end

  def error_summary(form_object)
    return unless GovukElementsErrorsHelper.errors_exist?(form_object)

    content_for(:page_title, flush: true) do
      content_for(:page_title).insert(0, t('errors.page_title_prefix'))
    end

    GovukElementsErrorsHelper.error_summary(
      form_object,
      t('errors.error_summary.heading'),
      t('errors.error_summary.text')
    )
  end

  def analytics_tracking_id
    ENV['GA_TRACKING_ID']
  end

  def service_name
    t('service.name')
  end

  def title(page_title)
    content_for :page_title, [page_title.presence, service_name, 'GOV.UK'].compact.join(' - ')
  end

  # We send a notification to Sentry to be alerted about any missing page titles.
  # If this happens, the title will default to a generic title for the service
  def fallback_title
    exception = StandardError.new("page title missing: #{controller_name}##{action_name}")
    raise exception if Rails.application.config.consider_all_requests_local
    Raven.capture_exception(exception)

    title ''
  end

  # Use this to feature-flag code that should only show in test environments
  def dev_tools_enabled?
    Rails.env.development? || %w[true yes 1].include?(ENV['DEV_TOOLS_ENABLED'])
  end
end
