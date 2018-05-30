require 'rails_helper'

RSpec.describe Steps::Completion::WhatNextController, type: :controller do
  it_behaves_like 'a show step controller'

  # context 'in standard interactions' do
  #   let(:court){ instance_double(Court) }
  #   before do
  #     allow(subject).to receive(:court_from_screener_answers).and_return(court)
  #   end
  #
  #   it_behaves_like 'a show step controller'
  #   it_behaves_like 'a completion step controller'
  # end
end
