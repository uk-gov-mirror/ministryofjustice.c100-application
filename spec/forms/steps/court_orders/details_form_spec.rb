require 'spec_helper'

RSpec.describe Steps::CourtOrders::DetailsForm do
  let(:arguments) { {
    c100_application: c100_application,

    non_molestation: non_molestation,
    non_molestation_issue_date: non_molestation_issue_date,
    non_molestation_length: non_molestation_length,
    non_molestation_is_current: non_molestation_is_current,
    non_molestation_court_name: non_molestation_court_name,

    occupation: occupation,
    occupation_issue_date: occupation_issue_date,
    occupation_length: occupation_length,
    occupation_is_current: occupation_is_current,
    occupation_court_name: occupation_court_name,

    forced_marriage_protection: forced_marriage_protection,
    forced_marriage_protection_issue_date: forced_marriage_protection_issue_date,
    forced_marriage_protection_length: forced_marriage_protection_length,
    forced_marriage_protection_is_current: forced_marriage_protection_is_current,
    forced_marriage_protection_court_name: forced_marriage_protection_court_name,

    restraining: restraining,
    restraining_issue_date: restraining_issue_date,
    restraining_length: restraining_length,
    restraining_is_current: restraining_is_current,
    restraining_court_name: restraining_court_name,

    injunctive: injunctive,
    injunctive_issue_date: injunctive_issue_date,
    injunctive_length: injunctive_length,
    injunctive_is_current: injunctive_is_current,
    injunctive_court_name: injunctive_court_name,

    undertaking: undertaking,
    undertaking_issue_date: undertaking_issue_date,
    undertaking_length: undertaking_length,
    undertaking_is_current: undertaking_is_current,
    undertaking_court_name: undertaking_court_name
  } }

  let(:c100_application) { instance_double(C100Application, court_order: court_order) }
  let(:court_order) { double('court_order') }

  let(:non_molestation) { 'no' }
  let(:non_molestation_issue_date) { nil }
  let(:non_molestation_length) { nil }
  let(:non_molestation_is_current) { nil }
  let(:non_molestation_court_name) { nil }

  let(:occupation) { 'no' }
  let(:occupation_issue_date) { nil }
  let(:occupation_length) { nil }
  let(:occupation_is_current) { nil }
  let(:occupation_court_name) { nil }

  let(:forced_marriage_protection) { 'no' }
  let(:forced_marriage_protection_issue_date) { nil }
  let(:forced_marriage_protection_length) { nil }
  let(:forced_marriage_protection_is_current) { nil }
  let(:forced_marriage_protection_court_name) { nil }

  let(:restraining) { 'no' }
  let(:restraining_issue_date) { nil }
  let(:restraining_length) { nil }
  let(:restraining_is_current) { nil }
  let(:restraining_court_name) { nil }

  let(:injunctive) { 'no' }
  let(:injunctive_issue_date) { nil }
  let(:injunctive_length) { nil }
  let(:injunctive_is_current) { nil }
  let(:injunctive_court_name) { nil }

  let(:undertaking) { 'no' }
  let(:undertaking_issue_date) { nil }
  let(:undertaking_length) { nil }
  let(:undertaking_is_current) { nil }
  let(:undertaking_court_name) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations on field presence' do
      it { should validate_presence_of(:non_molestation, :inclusion) }
      it { should validate_presence_of(:occupation, :inclusion) }
      it { should validate_presence_of(:forced_marriage_protection, :inclusion) }
      it { should validate_presence_of(:restraining, :inclusion) }
      it { should validate_presence_of(:injunctive, :inclusion) }
      it { should validate_presence_of(:undertaking, :inclusion) }
    end

    context 'validation on `non_molestation` order fields' do
      context 'when order value is `yes`' do
        let(:non_molestation) { 'yes' }

        it { should validate_presence_of(:non_molestation_issue_date) }
        it { should validate_presence_of(:non_molestation_length) }
        it { should validate_presence_of(:non_molestation_is_current, :inclusion) }
        it { should validate_presence_of(:non_molestation_court_name) }
      end

      context 'when order value is `no`' do
        let(:non_molestation) { 'no' }

        it { should_not validate_presence_of(:non_molestation_issue_date) }
        it { should_not validate_presence_of(:non_molestation_length) }
        it { should_not validate_presence_of(:non_molestation_is_current) }
        it { should_not validate_presence_of(:non_molestation_court_name) }
      end
    end

    context 'validation on `occupation` order fields' do
      context 'when order value is `yes`' do
        let(:occupation) { 'yes' }

        it { should validate_presence_of(:occupation_issue_date) }
        it { should validate_presence_of(:occupation_length) }
        it { should validate_presence_of(:occupation_is_current, :inclusion) }
        it { should validate_presence_of(:occupation_court_name) }
      end

      context 'when order value is `no`' do
        let(:occupation) { 'no' }

        it { should_not validate_presence_of(:occupation_issue_date) }
        it { should_not validate_presence_of(:occupation_length) }
        it { should_not validate_presence_of(:occupation_is_current) }
        it { should_not validate_presence_of(:occupation_court_name) }
      end
    end

    context 'validation on `forced_marriage_protection` order fields' do
      context 'when order value is `yes`' do
        let(:forced_marriage_protection) { 'yes' }

        it { should validate_presence_of(:forced_marriage_protection_issue_date) }
        it { should validate_presence_of(:forced_marriage_protection_length) }
        it { should validate_presence_of(:forced_marriage_protection_is_current, :inclusion) }
        it { should validate_presence_of(:forced_marriage_protection_court_name) }
      end

      context 'when order value is `no`' do
        let(:forced_marriage_protection) { 'no' }

        it { should_not validate_presence_of(:forced_marriage_protection_issue_date) }
        it { should_not validate_presence_of(:forced_marriage_protection_length) }
        it { should_not validate_presence_of(:forced_marriage_protection_is_current) }
        it { should_not validate_presence_of(:forced_marriage_protection_court_name) }
      end
    end

    context 'validation on `restraining` order fields' do
      context 'when order value is `yes`' do
        let(:restraining) { 'yes' }

        it { should validate_presence_of(:restraining_issue_date) }
        it { should validate_presence_of(:restraining_length) }
        it { should validate_presence_of(:restraining_is_current, :inclusion) }
        it { should validate_presence_of(:restraining_court_name) }
      end

      context 'when order value is `no`' do
        let(:restraining) { 'no' }

        it { should_not validate_presence_of(:restraining_issue_date) }
        it { should_not validate_presence_of(:restraining_length) }
        it { should_not validate_presence_of(:restraining_is_current) }
        it { should_not validate_presence_of(:restraining_court_name) }
      end
    end

    context 'validation on `injunctive` order fields' do
      context 'when order value is `yes`' do
        let(:injunctive) { 'yes' }

        it { should validate_presence_of(:injunctive_issue_date) }
        it { should validate_presence_of(:injunctive_length) }
        it { should validate_presence_of(:injunctive_is_current, :inclusion) }
        it { should validate_presence_of(:injunctive_court_name) }
      end

      context 'when order value is `no`' do
        let(:injunctive) { 'no' }

        it { should_not validate_presence_of(:injunctive_issue_date) }
        it { should_not validate_presence_of(:injunctive_length) }
        it { should_not validate_presence_of(:injunctive_is_current) }
        it { should_not validate_presence_of(:injunctive_court_name) }
      end
    end

    context 'validation on `undertaking` order fields' do
      context 'when order value is `yes`' do
        let(:undertaking) { 'yes' }

        it { should validate_presence_of(:undertaking_issue_date) }
        it { should validate_presence_of(:undertaking_length) }
        it { should validate_presence_of(:undertaking_is_current, :inclusion) }
        it { should validate_presence_of(:undertaking_court_name) }
      end

      context 'when order value is `no`' do
        let(:undertaking) { 'no' }

        it { should_not validate_presence_of(:undertaking_issue_date) }
        it { should_not validate_presence_of(:undertaking_length) }
        it { should_not validate_presence_of(:undertaking_is_current) }
        it { should_not validate_presence_of(:undertaking_court_name) }
      end
    end

    context 'for valid details' do
      it_behaves_like 'a has-one-association form',
                      association_name: :court_order,
                      expected_attributes: {
                        non_molestation: GenericYesNo::NO,
                        non_molestation_issue_date: nil,
                        non_molestation_length: nil,
                        non_molestation_is_current: nil,
                        non_molestation_court_name: nil,

                        occupation: GenericYesNo::NO,
                        occupation_issue_date: nil,
                        occupation_length: nil,
                        occupation_is_current: nil,
                        occupation_court_name: nil,

                        forced_marriage_protection: GenericYesNo::NO,
                        forced_marriage_protection_issue_date: nil,
                        forced_marriage_protection_length: nil,
                        forced_marriage_protection_is_current: nil,
                        forced_marriage_protection_court_name: nil,

                        restraining: GenericYesNo::NO,
                        restraining_issue_date: nil,
                        restraining_length: nil,
                        restraining_is_current: nil,
                        restraining_court_name: nil,

                        injunctive: GenericYesNo::NO,
                        injunctive_issue_date: nil,
                        injunctive_length: nil,
                        injunctive_is_current: nil,
                        injunctive_court_name: nil,

                        undertaking: GenericYesNo::NO,
                        undertaking_issue_date: nil,
                        undertaking_length: nil,
                        undertaking_is_current: nil,
                        undertaking_court_name: nil,
                      }
    end
  end
end
