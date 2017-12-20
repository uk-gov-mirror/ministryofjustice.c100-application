class BaseDecisionTree
  class InvalidStep < RuntimeError; end

  include ApplicationHelper

  attr_reader :c100_application, :record, :step_params, :as, :next_step

  def initialize(c100_application:, record: nil, step_params: {}, as: nil, next_step: nil)
    @c100_application = c100_application
    @record = record
    @step_params = step_params
    @as = as
    @next_step = next_step
  end

  private

  def step_name
    (as || step_params.keys.first).to_sym
  end

  def question(attribute_name, klass = GenericYesNo)
    value = c100_application.public_send(attribute_name)
    klass.new(value) if value
  end

  def checked?(attribute_name)
    step_params.fetch(attribute_name, '0').true?
  end

  def selected?(attribute_name, value: 'yes')
    step_params.fetch(attribute_name).eql?(value)
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

  def next_record_id(collection_ids, current: record)
    @_next_record_id ||= begin
      return collection_ids.first if current.nil?

      pos = collection_ids.index(current.id)
      collection_ids.at(pos + 1)
    end
  end
end
