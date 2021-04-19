require 'spec_helper'

describe CookieForm do
  subject(:form) { described_class.new }
  describe 'allow_analytics=' do
    it 'stores the value' do
      form.allow_analytics = true
      expect(form.allow_analytics).to be true
    end
  end
end
