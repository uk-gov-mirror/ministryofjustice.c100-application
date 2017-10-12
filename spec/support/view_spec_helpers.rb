module ViewSpecHelpers
  def initialize_view_helpers(view)
    view.extend ControllerViewHelpers
  end
end
