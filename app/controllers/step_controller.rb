class StepController < ApplicationController
  before_action :check_c100_application_presence
  before_action :update_navigation_stack

  def previous_step_path
    # Second to last element in the array, will be nil for arrays of size 0 or 1
    current_c100_application&.navigation_stack&.slice(-2) || root_path
  end
  helper_method :previous_step_path

  private

  def update_and_advance(form_class, opts = {})
    hash = permitted_params(form_class).to_h

    @next_step   = params[:next_step].presence
    @form_object = form_class.new(
      hash.merge(c100_application: current_c100_application, record_id: opts[:record_id])
    )

    if @form_object.save
      destination = decision_tree_class.new(
        c100_application: current_c100_application,
        step_params:   hash,
        # Used when the step name in the decision tree is not the same as the first
        # (and usually only) attribute in the form.
        as:            opts[:as],
        next_step:     @next_step
      ).destination

      redirect_to destination
    else
      render opts.fetch(:render, :edit)
    end
  end

  def permitted_params(form_class)
    params
      .fetch(form_class.model_name.singular, {})
      .permit(form_attribute_names(form_class))
  end

  def form_attribute_names(form_class)
    form_class.attribute_set.map do |attr|
      attr_name = attr.name
      primitive = attr.primitive

      primitive.eql?(Date) ? %W[#{attr_name}_dd #{attr_name}_mm #{attr_name}_yyyy] : attr_name
    end.flatten
  end

  def update_navigation_stack
    return unless current_c100_application

    stack_until_current_page = current_c100_application.navigation_stack.take_while do |path|
      path != request.fullpath
    end

    current_c100_application.navigation_stack = stack_until_current_page + [request.fullpath]
    current_c100_application.save!
  end
end
