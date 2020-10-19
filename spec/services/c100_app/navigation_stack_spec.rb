require 'rails_helper'

RSpec.describe C100App::NavigationStack do
  subject { described_class.new(c100_application, request) }

  let(:c100_application) { C100Application.new(navigation_stack: navigation_stack) }
  let(:request) { double('Request', session: session, fullpath: '/dummy_step') }
  let(:session) { double('Session') }

  let(:navigation_stack) { [] }

  before do
    allow(session).to receive(:[]=)
    allow(c100_application).to receive(:save!)
  end

  describe '#update!' do
    it 'does not `touch` timestamps on save' do
      expect(c100_application).to receive(:save!).with(touch: false)
      subject.update!
    end

    it 'sets the CYA origin flag to `false`' do
      expect(session).to receive(:[]=).with(:cya_origin, false)
      subject.update!
    end

    context 'when the stack is empty' do
      let(:navigation_stack) { [] }

      it 'adds the page to the stack' do
        subject.update!
        expect(c100_application.navigation_stack).to eq(['/dummy_step'])
      end
    end

    context 'when the current page is on the stack' do
      let(:navigation_stack) { %w(/foo /bar /dummy_step /baz )}

      it 'rewinds the stack to the appropriate point' do
        subject.update!
        expect(c100_application.navigation_stack).to eq(%w(/foo /bar /dummy_step))
      end
    end

    context 'when the current page is not on the stack' do
      let(:navigation_stack) { %w(/foo /bar /baz) }

      it 'adds it to the end of the stack' do
        subject.update!
        expect(c100_application.navigation_stack).to eq(%w(/foo /bar /baz /dummy_step))
      end
    end

    context 'when coming from check your answers' do
      context 'for a complete funnel' do
        let(:navigation_stack) { %w(/foo /bar /dummy_step /steps/application/payment /steps/application/check_your_answers)}

        it 'sets the CYA origin flag to `true`' do
          expect(session).to receive(:[]=).with(:cya_origin, true)
          subject.update!
        end
      end

      context 'for an incomplete funnel' do
        let(:navigation_stack) { %w(/foo /bar /dummy_step /another_step /steps/application/check_your_answers)}

        it 'sets the CYA origin flag to `false`' do
          expect(session).to receive(:[]=).with(:cya_origin, false)
          subject.update!
        end
      end
    end
  end
end
