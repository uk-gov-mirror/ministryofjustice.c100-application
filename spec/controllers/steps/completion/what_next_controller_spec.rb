require 'rails_helper'

RSpec.describe Steps::Completion::WhatNextController, type: :controller do
  context 'in standard interactions' do
    let(:court){ instance_double(Court) }
    before do
      allow(subject).to receive(:court_from_screener_answers).and_return(court)
    end

    it_behaves_like 'a show step controller'
    it_behaves_like 'a completion step controller'
  end

  describe '#court_from_screener_answers' do
    let(:screener_answers){ instance_double(ScreenerAnswers, local_court: local_court) }
    let(:c100_application){ instance_double(C100Application, screener_answers: screener_answers)}
    before do
      allow(subject).to receive(:current_c100_application).and_return(c100_application)
    end

    context 'when there is a local_court in screener_answers' do
      let(:local_court){ {} }
      let(:new_court){ instance_double(Court) }

      before do
        allow(c100_application).to receive(:screener_answers).and_return(screener_answers)
        allow_any_instance_of(Court).to receive(:from_courtfinder_data!).with(local_court).and_return(new_court)

      end

      it 'creates a new Court from_court_finder_data passing the local_court' do
        expect_any_instance_of(Court).to receive(:from_courtfinder_data!).with(local_court)
        subject.send(:court_from_screener_answers)
      end

      it 'returns the new Court' do
        expect(subject.send(:court_from_screener_answers)).to eq(new_court)
      end
    end

    context 'when there is no local_court in screener_answers' do
      let(:local_court){ nil }
      it 'returns a new Court' do
        expect(subject.send(:court_from_screener_answers)).to be_a(Court)
      end

      describe 'the returned Court' do
        let(:returned_court){ subject.send(:court_from_screener_answers) }
        it 'has nil instance_variables' do
          expect(returned_court.instance_variables).to be_empty
        end
      end
    end
  end
end
