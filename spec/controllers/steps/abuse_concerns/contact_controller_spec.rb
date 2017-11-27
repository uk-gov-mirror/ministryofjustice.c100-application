require 'rails_helper'

RSpec.describe Steps::AbuseConcerns::ContactController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::AbuseConcerns::ContactForm, C100App::AbuseConcernsDecisionTree
end
