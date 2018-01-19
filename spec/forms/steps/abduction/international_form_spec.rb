require 'spec_helper'

RSpec.describe Steps::Abduction::InternationalForm do
  let(:arguments) { {
    c100_application: c100_application,
    international_risk: international_risk,
    passport_office_notified: passport_office_notified
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:international_risk) { 'yes' }
  let(:passport_office_notified) { 'no' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:international_risk, :inclusion) }

      context 'when `international_risk` is yes' do
        let(:international_risk) { 'yes' }
        it { should validate_presence_of(:passport_office_notified, :inclusion) }
      end

      context 'when `international_risk` is no' do
        let(:international_risk) { 'no' }
        it { should_not validate_presence_of(:passport_office_notified, :inclusion) }
      end
    end

    it_behaves_like 'a has-one-association form',
                    association_name: :abduction_detail,
                    expected_attributes: {
                      international_risk: GenericYesNo::YES,
                      passport_office_notified: GenericYesNo::NO
                    }
  end
end
