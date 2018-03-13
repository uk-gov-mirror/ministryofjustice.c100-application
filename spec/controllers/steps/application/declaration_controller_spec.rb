require 'rails_helper'

RSpec.describe Steps::Application::DeclarationController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::DeclarationForm, C100App::ApplicationDecisionTree
end
