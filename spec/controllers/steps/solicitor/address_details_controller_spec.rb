require 'rails_helper'

RSpec.describe Steps::Solicitor::AddressDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Solicitor::AddressDetailsForm, C100App::SolicitorDecisionTree
end
