require 'rails_helper'

RSpec.describe Person, type: :model do
  subject { Person.new(first_name: first_name, last_name: last_name) }

  let(:first_name) { nil }
  let(:last_name)  { nil }

  describe '#full_name' do
    context 'for a person with first and last name attributes' do
      let(:first_name) { 'John' }
      let(:last_name) { 'Doe' }
      it { expect(subject.full_name).to eq('John Doe') }
    end

    context 'for a person with a first_name attribute' do
      let(:first_name) { 'John Doe' }
      it { expect(subject.full_name).to eq('John Doe') }
    end

    context 'for a person without a last_name attribute' do
      let(:last_name) { 'John Doe' }
      it { expect(subject.full_name).to eq('John Doe') }
    end
  end
end
