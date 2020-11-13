class Solicitor < ApplicationRecord
  include PersonWithAddress

  belongs_to :c100_application

  # TODO: we need to maintain backwards compatibility for some time
  # with the old "free text area" address attrib. Once all applications
  # are using the structured `address_data`, we can remove this method.
  # If both, old and new data are present, we prioritise the new data.
  #
  def full_address
    super().presence || address
  end
end
