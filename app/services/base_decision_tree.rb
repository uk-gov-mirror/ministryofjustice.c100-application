class BaseDecisionTree
  class InvalidStep < RuntimeError; end

  include ApplicationHelper

  attr_reader :c100_application, :step_params, :as, :next_step

  def initialize(c100_application:, step_params: {}, as: nil, next_step: nil)
    @c100_application = c100_application
    @step_params = step_params
    @as = as
    @next_step = next_step
  end

  private

  def step_name
    (as || step_params.keys.first).to_sym
  end

  def question(attribute_name, klass = GenericYesNo)
    klass.new c100_application.public_send(attribute_name)
  end

  def checked?(attribute_name)
    step_params.fetch(attribute_name, '0').true?
  end

  # Enable again when needed. Coverage complains otherwise.
  # def root_path
  #   { controller: '/entrypoint', action: :v1 }
  # end

  def show(step_controller)
    {controller: step_controller, action: :show}
  end

  def edit(step_controller, params = {})
    {controller: step_controller, action: :edit}.merge(params)
  end
end
