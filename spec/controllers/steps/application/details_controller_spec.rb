require 'rails_helper'

RSpec.describe Steps::Application::DetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::DetailsForm, C100App::ApplicationDecisionTree
end
