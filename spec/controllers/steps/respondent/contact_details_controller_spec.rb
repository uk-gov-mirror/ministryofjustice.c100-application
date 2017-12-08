require 'rails_helper'

RSpec.describe Steps::Respondent::ContactDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Respondent::ContactDetailsForm, C100App::RespondentDecisionTree
end
