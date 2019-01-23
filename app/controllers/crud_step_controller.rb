class CrudStepController < StepController
  private

  # :nocov:
  def names_form_class
    raise 'implement in subclasses'
  end

  def record_collection
    raise 'implement in subclasses'
  end

  # Until we've migrated all database records to the new first/last name
  # structure, we must maintain backward-compatibility. Only c100 records
  # greater than this version will be eligible for the new split format.
  #
  def split_names?
    current_c100_application.version > 1
  end
  # :nocov:

  def current_record
    @_current_record ||= record_collection.find_or_initialize_by(id: params[:id])
  end

  def set_existing_records
    @existing_records = record_collection.persisted
  end
end
