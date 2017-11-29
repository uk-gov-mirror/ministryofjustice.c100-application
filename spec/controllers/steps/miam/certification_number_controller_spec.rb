require 'rails_helper'

RSpec.describe Steps::Miam::CertificationNumberController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Miam::CertificationNumberForm, C100App::MiamDecisionTree
end
