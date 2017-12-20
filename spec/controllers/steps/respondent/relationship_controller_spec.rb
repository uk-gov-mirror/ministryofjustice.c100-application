require 'rails_helper'

RSpec.describe Steps::Respondent::RelationshipController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Respondent::RelationshipForm, C100App::RespondentDecisionTree
end
