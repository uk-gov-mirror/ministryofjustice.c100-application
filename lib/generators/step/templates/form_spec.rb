require 'spec_helper'

RSpec.describe Steps::<%= task_name.camelize %>::<%= step_name.camelize %>Form do
  let(:arguments) { {
    c100_application: c100_application,
    <%= step_name.underscore %>: <%= step_name.underscore %>
  } }
  let(:c100_application) { instance_double(C100Application, <%= step_name.underscore %>: nil) }
  let(:<%= step_name.underscore %>) { nil }

  subject { described_class.new(arguments) }

  pending 'Write specs for <%= step_name.camelize %>Form!'

  # TODO: The below can be uncommented and serves as a starting point for
  #   forms operating on a single value object.

  # describe '.choices' do
  #   it 'returns the relevant choices' do
  #     expect(described_class.choices).to eq(%w(
  #       one_choice
  #       another_choice
  #     ))
  #   end
  # end

  # describe '#save' do
  #   context 'when no c100_application is associated with the form' do
  #     let(:c100_application)  { nil }
  #     let(:<%= step_name.underscore %>) { 'value' } # This must be a correct value

  #     it 'raises an error' do
  #       expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
  #     end
  #   end

  #   context 'when <%= step_name.underscore %> is not given' do
  #     it 'returns false' do
  #       expect(subject.save).to be(false)
  #     end

  #     it 'has a validation error on the field' do
  #       expect(subject).to_not be_valid
  #       expect(subject.errors[:<%= step_name.underscore %>]).to_not be_empty
  #     end
  #   end

  #   context 'when <%= step_name.underscore %> is not valid' do
  #     let(:<%= step_name.underscore %>) { 'INVALID VALUE' }

  #     it 'returns false' do
  #       expect(subject.save).to be(false)
  #     end

  #     it 'has a validation error on the field' do
  #       expect(subject).to_not be_valid
  #       expect(subject.errors[:<%= step_name.underscore %>]).to_not be_empty
  #     end
  #   end

  #   context 'when <%= step_name.underscore %> is valid' do
  #     let(:<%= step_name.underscore %>) { 'INSERT VALID VALUE HERE' }

  #     it 'saves the record' do
  #       expect(c100_application).to receive(:update).with(
  #         # TODO: What's in the update?
  #       ).and_return(true)
  #       expect(subject.save).to be(true)
  #     end
  #   end

  #   context 'when <%= step_name.underscore %> is already the same on the model' do
  #     let(:c100_application) {
  #       instance_double(
  #         C100Application,
  #         <%= step_name.underscore %>: 'INSERT EXISTING VALUE HERE'
  #       )
  #     }
  #     let(:<%= step_name.underscore %>) { 'CHANGEME' }

  #     it 'does not save the record but returns true' do
  #       # Mutant killer. Uncomment and change the `_value` method name if needed.
  #       # expect(subject).to receive(:case_type_value).and_call_original
  #       expect(c100_application).to_not receive(:update)
  #       expect(subject.save).to be(true)
  #     end
  #   end
  # end
end
