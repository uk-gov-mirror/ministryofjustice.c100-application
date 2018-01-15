require 'rails_helper'

RSpec.describe Steps::Application::LitigationCapacityDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::LitigationCapacityDetailsForm, C100App::ApplicationDecisionTree
end
