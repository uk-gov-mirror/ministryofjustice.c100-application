require 'rails_helper'

RSpec.describe Steps::Respondent::UnderAgeController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Shared::UnderAgeForm, C100App::RespondentDecisionTree
end
