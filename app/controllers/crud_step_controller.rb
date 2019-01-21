class CrudStepController < StepController
  private

  # :nocov:
  def names_form_class
    raise 'implement in subclasses'
  end

  def record_collection
    raise 'implement in subclasses'
  end

  def split_names?
    current_c100_application.version > 1 || ENV.key?('SPLIT_NAMES')
  end
  # :nocov:

  def current_record
    @_current_record ||= record_collection.find_or_initialize_by(id: params[:id])
  end

  def set_existing_records
    @existing_records = record_collection.persisted
  end
end
