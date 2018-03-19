require 'rails_helper'

RSpec.describe C100App::Status do
  let(:status) do
    {
      service_status: service_status,
      version: 'ABC123',
      dependencies: {
        database_status: database_status,
        courtfinder_status: courtfinder_status,
      }
    }
  end

  # Default is everything is fine
  let(:service_status) { 'ok' }
  let(:database_status) { 'ok' }
  let(:courtfinder_status) { 'ok' }
  let(:courtfinder_api_is_ok) { true }

  before do
    allow(ActiveRecord::Base).to receive(:connection).and_return(double)
    allow_any_instance_of(described_class).to receive(:`).with('git rev-parse HEAD').and_return('ABC123')
    allow_any_instance_of(C100App::CourtfinderAPI).to receive(:is_ok?).and_return(courtfinder_api_is_ok)
  end

  describe '.version' do
    let(:git_result) { double('git_result') }

    # Necessary evil for coverage purposes.
    it 'calls `git rev-parse HEAD`' do
      # See above
      expect_any_instance_of(described_class).to receive(:`).with('git rev-parse HEAD').and_return(git_result)
      expect(git_result).to receive(:chomp)
      described_class.check
    end
  end

  describe '#service_status' do
    before do
      allow(subject).to receive(:database_status).and_return(database_status)
      allow(subject).to receive(:courtfinder_status).and_return(courtfinder_status)
    end
    context 'when database_status is "ok"' do
      let(:database_status) { 'ok' }

      context 'when courtfinder_status is "ok"' do
        let(:courtfinder_status) { 'ok' }

        it 'returns ok' do
          expect(subject.send(:service_status)).to eq('ok')
        end
      end

      context 'when courtfinder_status is not "ok"' do
        let(:courtfinder_status) { 'foo' }

        it 'returns failed' do
          expect(subject.send(:service_status)).to eq('failed')
        end
      end
    end
    context 'when courtfinder_status is "ok"' do
      let(:courtfinder_status) { 'ok' }

      context 'when database_status is not "ok"' do
        let(:database_status) { 'foo' }

        it 'returns failed' do
          expect(subject.send(:service_status)).to eq('failed')
        end
      end
    end
  end

  describe '#check' do
    context 'database available' do
      let(:courtfinder_api_is_ok){ true }
      before do
        expect(ActiveRecord::Base).to receive(:connection).and_call_original
      end

      specify { expect(described_class.check).to eq(status) }
    end

    context 'database unavailable' do
      let(:service_status) { 'failed' }
      let(:database_status) { 'failed' }

      before do
        expect(ActiveRecord::Base).to receive(:connection).and_return(nil)
      end

      specify { expect(described_class.check).to eq(status) }
    end

    describe 'Courtfinder API status' do
      context 'when CourtfinderAPI.status.is_ok?' do
        let(:courtfinder_api_is_ok){ true }

        specify { expect(described_class.check).to eq(status) }
      end
      context 'when it is not OK' do
        let(:courtfinder_api_is_ok){ false }
        let(:service_status) { 'failed' }
        let(:courtfinder_status) { 'failed' }

        specify { expect(described_class.check).to eq(status) }
      end
    end
  end
end
