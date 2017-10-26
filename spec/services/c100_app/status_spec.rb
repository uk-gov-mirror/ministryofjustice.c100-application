require 'rails_helper'

RSpec.describe C100App::Status do
  let(:status) do
    {
      service_status: service_status,
      version: 'ABC123',
      dependencies: {
        database_status: database_status,
      }
    }
  end

  # Default is everything is fine
  let(:service_status) { 'ok' }
  let(:database_status) { 'ok' }

  before do
    allow(ActiveRecord::Base).to receive(:connection).and_return(double)
    allow_any_instance_of(described_class).to receive(:`).with('git rev-parse HEAD').and_return('ABC123')
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

  describe '#check' do
    context 'database available' do
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
  end
end
