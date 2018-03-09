require 'rails_helper'

RSpec.describe Steps::Miam::ChildProtectionCasesController, type: :controller do
  it_behaves_like 'a savepoint step controller'
  it_behaves_like 'an intermediate step controller', Steps::Miam::ChildProtectionCasesForm, C100App::MiamDecisionTree
end
