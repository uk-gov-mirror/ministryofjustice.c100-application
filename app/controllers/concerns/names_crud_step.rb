module NamesCrudStep
  extend ActiveSupport::Concern

  def edit
    @form_object = names_form_class.new(
      c100_application: current_c100_application
    )
  end

  def update
    update_and_advance(
      names_form_class,
      as: params.fetch(:button, :names_finished)
    )
  end

  def destroy
    current_record.destroy
    redirect_to action: :edit, id: nil
  end

  private

  def additional_permitted_params
    [names_attributes: [:id, names_form_class.name_attribute]]
  end
end
