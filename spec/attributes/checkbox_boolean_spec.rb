require 'rails_helper'

RSpec.describe CheckboxBoolean do
  subject { described_class.build(CheckboxBoolean) }

  let(:coerced_value) { subject.coerce(value) }

  describe 'when value is `nil`' do
    let(:value) { nil }
    it { expect(coerced_value).to eq(false) }
  end

  describe 'when value is a string' do
    context 'for a blank string' do
      let(:value) { '' }
      it { expect(coerced_value).to eq('') }
    end

    context 'for a `false` string' do
      let(:value) { 'false' }
      it { expect(coerced_value).to eq(false) }
    end

    context 'for a `true` string' do
      let(:value) { 'true' }
      it { expect(coerced_value).to eq(true) }
    end

    context 'for any other string' do
      let(:value) { 'foobar' }
      it { expect(coerced_value).to eq('foobar') }
    end
  end

  describe 'when value is an array' do
    let(:value) { ['true'] }
    it { expect(coerced_value).to eq(true) }
  end
end
