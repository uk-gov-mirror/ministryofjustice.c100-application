require 'spec_helper'

RSpec.describe Steps::Shared::UnderAgeForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:record) { double('Applicant') }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    it 'does nothing on the record and return true' do
      expect(record).not_to receive(:update)
      expect(subject.save).to be(true)
    end
  end
end
