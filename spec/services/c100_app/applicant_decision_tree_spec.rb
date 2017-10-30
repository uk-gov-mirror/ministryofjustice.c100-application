require 'rails_helper'

RSpec.describe C100App::ApplicantDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `user_type`' do
    let(:step_params) {{'user_type' => 'anything'}}

    context 'and the user is a themself' do
      let(:c100_application) {instance_double(C100Application, user_type: UserType::THEMSELF)}

      it {is_expected.to have_destination(:user_type, :edit)}
    end

    context 'and the user is a representative' do
      let(:c100_application) {instance_double(C100Application, user_type: UserType::REPRESENTATIVE)}

      it {is_expected.to have_destination(:user_type, :edit)}
    end
  end
end
