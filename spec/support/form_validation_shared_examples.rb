RSpec.shared_examples 'a value object form' do |options|
  context 'when no c100_application is associated with the form' do
    let(:c100_application) { nil }
    let(options[:attribute_name]) { options[:example_value] }

    it 'raises an error' do
      expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
    end
  end

  context 'when attribute is not given' do
    let(options[:attribute_name]) { nil }

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors[options[:attribute_name]]).to_not be_empty
    end
  end

  context 'when attribute value is not valid' do
    let(options[:attribute_name]) { 'INVALID VALUE' }

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors[options[:attribute_name]]).to_not be_empty
    end
  end
end

RSpec.shared_examples 'a yes-no question form' do |options|
  let(:question_attribute) { options[:attribute_name] }
  let(:answer_value) { 'yes' }

  let(:reset_when_yes) { options.fetch(:reset_when_yes, []) }
  let(:reset_when_no)  { options.fetch(:reset_when_no,  []) }

  let(:arguments) { {
    c100_application: c100_application,
    question_attribute => answer_value
  } }

  let(:c100_application) { instance_double(C100Application) }

  def attributes_to_reset(attrs)
    Hash[attrs.collect {|att| [att, nil]}]
  end

  describe 'validations on field presence' do
    it { should validate_presence_of(question_attribute, :inclusion) }
  end

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { described_class.new(arguments).save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when answer is `yes`' do
      let(:answer_value) { 'yes' }
      let(:additional_attributes) { attributes_to_reset(reset_when_yes) }

      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          { options[:attribute_name] => GenericYesNo::YES }.merge(additional_attributes)
        ).and_return(true)
        expect(described_class.new(arguments).save).to be(true)
      end
    end

    context 'when answer is `no`' do
      let(:answer_value) { 'no' }
      let(:additional_attributes) { attributes_to_reset(reset_when_no) }

      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          { options[:attribute_name] => GenericYesNo::NO }.merge(additional_attributes)
        ).and_return(true)
        expect(described_class.new(arguments).save).to be(true)
      end
    end
  end
end
