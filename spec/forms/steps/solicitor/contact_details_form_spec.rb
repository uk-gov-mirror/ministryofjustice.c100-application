require 'spec_helper'

RSpec.describe Steps::Solicitor::ContactDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    address: 'address',
    dx_number: 'dx_number',
    phone_number: 'phone_number',
    fax_number: 'fax_number',
    email: email,
  } }

  let(:email) { 'test@example.com' }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:address) }
      it { should validate_presence_of(:phone_number) }

      context 'email validation' do
        context 'email is not validated if not present' do
          let(:email) { nil }
          it { expect(subject).to be_valid }
        end

        context 'email is validated if present' do
          let(:email) { 'xxx' }
          it {
            expect(subject).not_to be_valid
            expect(subject.errors[:email]).to_not be_empty
          }
        end
      end
    end

    it_behaves_like 'a has-one-association form',
                    association_name: :solicitor,
                    expected_attributes: {
                      address: 'address',
                      dx_number: 'dx_number',
                      phone_number: 'phone_number',
                      fax_number: 'fax_number',
                      email: 'test@example.com',
                    }
  end
end
