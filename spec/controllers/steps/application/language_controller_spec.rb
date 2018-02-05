require 'rails_helper'

RSpec.describe Steps::Application::LanguageController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::LanguageForm, C100App::ApplicationDecisionTree
end
