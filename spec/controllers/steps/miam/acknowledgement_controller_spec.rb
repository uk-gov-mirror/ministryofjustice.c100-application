require 'rails_helper'

RSpec.describe Steps::Miam::AcknowledgementController, type: :controller do
  it_behaves_like 'a starting point step controller'
  it_behaves_like 'an intermediate step controller', Steps::Miam::AcknowledgementForm, C100App::MiamDecisionTree
end
