module CrudStep
  extend ActiveSupport::Concern

  included do
    before_action :set_existing_records
  end

  def destroy
    current_record.destroy
    redirect_to action: :edit, id: @existing_records.first
  end

  private

  # :nocov:
  def record_collection
    raise 'implement in the class including this module'
  end
  # :nocov:

  def current_record
    @_current_record ||= record_collection.find_or_initialize_by(id: params[:id])
  end

  def set_existing_records
    @existing_records = record_collection.persisted
  end
end
