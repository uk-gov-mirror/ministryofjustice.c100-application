class StepGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :task_name,  type: :string
  argument :step_name,  type: :string
  class_option :type,   type: :string, required: false, default: 'edit'

  def validate_options!
    %w(show edit).include?(type) ||
      raise('Unknown value for `--type` option. Valid options: `show|edit`. Default: `edit`')
  end

  def copy_controller
    template "#{type}/controller.rb", "app/controllers/steps/#{task_name.underscore}/#{step_name.underscore}_controller.rb"
    template "#{type}/controller_spec.rb", "spec/controllers/steps/#{task_name.underscore}/#{step_name.underscore}_controller_spec.rb"
  end

  def copy_template
    template "#{type}/#{template_name}.html.erb", "app/views/steps/#{task_name.underscore}/#{step_name.underscore}/#{template_name}.html.erb"
  end

  def copy_form
    return if type == 'show' # show steps doesn't have form objects
    template "#{type}/form.rb", "app/forms/steps/#{task_name.underscore}/#{step_name.underscore}_form.rb"
    template "#{type}/form_spec.rb", "spec/forms/steps/#{task_name.underscore}/#{step_name.underscore}_form_spec.rb"
  end

  # Prepared to cope with type `crud` in the future. Add here another branch.
  def add_step_to_routes
    case type
    when 'show'
      add_to_routes("show_step :#{step_name.underscore}")
    else
      add_to_routes("edit_step :#{step_name.underscore}")
    end
  end

  private

  def add_to_routes(step_line)
    insert_into_file('config/routes.rb', after: /namespace :#{task_name.underscore} do.+?(?=end)/m) { "  #{step_line}\n    " }
  end

  # Supplied as an optional parameter in the command line with `--type=show|edit`
  # Default value if option not passed is `edit`
  def type
    options.type
  end

  # Currently, the type (`show` or `edit`) also matches the template name `show.html.erb` `edit.html.erb`
  # but this method exists to be able to cope with other types in the future (for example we could have a
  # new type named `crud` which will have a `edit.html.erb` template and other few differences).
  def template_name
    type
  end
end
