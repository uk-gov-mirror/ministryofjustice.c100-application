require 'rails_helper'

RSpec.describe Steps::Application::UrgentHearingDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::UrgentHearingDetailsForm, C100App::ApplicationDecisionTree
end
