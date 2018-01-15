require 'rails_helper'

RSpec.describe Steps::Application::SpecialArrangementsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::SpecialArrangementsForm, C100App::ApplicationDecisionTree
end
