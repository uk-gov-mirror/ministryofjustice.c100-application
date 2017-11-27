require 'spec_helper'

RSpec.describe Steps::Abduction::InternationalForm do
  let(:arguments) { {
    c100_application: c100_application,
    international_risk: international_risk,
    passport_office_notified: passport_office_notified,
    children_multiple_passports: 'no',
    passport_possession_mother: true,
    passport_possession_father: false,
    passport_possession_other: passport_possession_other,
    passport_possession_other_details: nil
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:international_risk) { 'yes' }
  let(:passport_office_notified) { 'no' }
  let(:passport_possession_other) { false }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:international_risk, :inclusion) }
      it { should validate_presence_of(:children_multiple_passports, :inclusion) }

      context 'when `international_risk` is yes' do
        let(:international_risk) { 'yes' }
        it { should validate_presence_of(:passport_office_notified, :inclusion) }
      end

      context 'when `international_risk` is no' do
        let(:international_risk) { 'no' }
        it { should_not validate_presence_of(:passport_office_notified, :inclusion) }
      end

      context 'when `passport_possession_other_details` is checked' do
        let(:passport_possession_other) { true }
        it { should validate_presence_of(:passport_possession_other_details) }
      end

      context 'when `passport_possession_other_details` is not checked' do
        let(:passport_possession_other) { false }
        it { should validate_absence_of(:passport_possession_other_details) }
      end
    end

    it_behaves_like 'a has-one-association form',
                    association_name: :abduction_detail,
                    expected_attributes: {
                      international_risk: GenericYesNo::YES,
                      passport_office_notified: GenericYesNo::NO,
                      children_multiple_passports: GenericYesNo::NO,
                      passport_possession_mother: true,
                      passport_possession_father: false,
                      passport_possession_other: false,
                      passport_possession_other_details: nil
                    }
    end
end
