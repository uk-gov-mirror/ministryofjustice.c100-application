require 'rails_helper'

RSpec.describe Steps::Application::IntermediaryController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::IntermediaryForm, C100App::ApplicationDecisionTree
end
