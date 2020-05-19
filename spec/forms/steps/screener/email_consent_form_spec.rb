require 'spec_helper'

RSpec.describe Steps::Screener::EmailConsentForm do
  let(:email_consent){ GenericYesNo::YES }
  let(:email_address){ 'my.email@example.com' }
  let(:arguments) { {
    c100_application: c100_application,
    email_consent: email_consent,
    email_address: email_address
  } }

  let(:c100_application){ instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:email_consent, :inclusion) }
      context 'when email_consent is yes' do
        let(:email_consent){ GenericYesNo::YES }
        context 'and email_address is a valid email address' do
          let(:email_address) { 'xxx@yyy.com' }
          it 'is valid' do
            expect(subject).to be_valid
          end
        end
        context 'and email_address is not a valid email address' do
          let(:email_address) { 'xxx' }
          it 'is not valid' do
            expect(subject).not_to be_valid
          end
          it 'has an error on the email_address attribute' do
            subject.valid?
            expect(subject.errors[:email_address]).to_not be_empty
          end
        end
      end
      context 'when email_consent is no' do
        let(:email_consent){ GenericYesNo::NO }
        context 'and email_address is not a valid email address' do
          let(:email_address) { 'xxx' }
          it 'is still valid' do
            expect(subject).to be_valid
          end
        end
      end
    end

    context 'when answer is yes' do
      let(:email_consent){ GenericYesNo::YES }

      it_behaves_like 'a has-one-association form',
                      association_name: :screener_answers,
                      expected_attributes: {
                        email_consent: GenericYesNo::YES,
                        email_address: 'my.email@example.com'
                      }
    end

    context 'when answer is no' do
      let(:email_consent){ GenericYesNo::NO }

      it_behaves_like 'a has-one-association form',
                      association_name: :screener_answers,
                      expected_attributes: {
                        email_consent: GenericYesNo::NO,
                        email_address: nil
                      }
    end
  end
end
