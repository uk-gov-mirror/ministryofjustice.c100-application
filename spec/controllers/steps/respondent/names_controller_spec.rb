require 'rails_helper'

RSpec.describe Steps::Respondent::NamesController, type: :controller do
  it_behaves_like 'an intermediate CRUD step controller',
                  Steps::Respondent::NamesForm,
                  C100App::RespondentDecisionTree,
                  Respondent
end
