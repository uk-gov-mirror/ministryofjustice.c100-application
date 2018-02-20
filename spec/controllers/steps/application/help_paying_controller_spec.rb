require 'rails_helper'

RSpec.describe Steps::Application::HelpPayingController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::HelpPayingForm, C100App::ApplicationDecisionTree
end
