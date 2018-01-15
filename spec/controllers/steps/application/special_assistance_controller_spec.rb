require 'rails_helper'

RSpec.describe Steps::Application::SpecialAssistanceController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::SpecialAssistanceForm, C100App::ApplicationDecisionTree
end
