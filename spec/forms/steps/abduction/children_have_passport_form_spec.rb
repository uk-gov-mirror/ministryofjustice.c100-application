require 'spec_helper'

RSpec.describe Steps::Abduction::ChildrenHavePassportForm do
  let(:arguments) { {
    c100_application: c100_application,
    children_have_passport: 'yes'
  } }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:children_have_passport, :inclusion) }
    end

    it_behaves_like 'a has-one-association form',
                    association_name: :abduction_detail,
                    expected_attributes: {
                      children_have_passport: GenericYesNo::YES,
                    }
  end
end
