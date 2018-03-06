require 'rails_helper'

class TestHelper < ActionView::Base
  def user_signed_in?
    false
  end

  def new_user_registration_path
    '/test/sign_up'
  end
end

# The module `CustomFormHelpers` gets mixed in and extends the helpers already
# provided by `GovukElementsFormBuilder`. Refer to: `config/initializers/form_builder.rb`
#
RSpec.describe GovukElementsFormBuilder::FormBuilder do
  let(:helper) { TestHelper.new }
  let(:resource) { Applicant.new }
  let(:builder) { described_class.new :applicant, resource, helper, {} }

  describe '#continue_button' do
    let(:c100_application) { C100Application.new(status: :in_progress) }
    let(:html_output) { builder.continue_button }

    before do
      allow(helper).to receive(:current_c100_application).and_return(c100_application)
    end

    context 'no c100 application yet' do
      let(:c100_application) { nil }

      it 'outputs the continue button' do
        expect(
          html_output
        ).to eq('<p class="actions"><input type="submit" name="commit" value="Continue" class="button" data-disable-with="Continue" /></p>')
      end
    end

    context 'for an application in screening' do
      let(:c100_application) { C100Application.new(status: :screening) }

      it 'outputs the continue button' do
        expect(
          html_output
        ).to eq('<p class="actions"><input type="submit" name="commit" value="Continue" class="button" data-disable-with="Continue" /></p>')
      end
    end

    context 'for a logged in user' do
      before do
        allow(helper).to receive(:user_signed_in?).and_return(true)
      end

      it 'outputs the save and continue button' do
        expect(
          html_output
        ).to eq('<p class="actions"><input type="submit" name="commit" value="Save and continue" class="button" data-disable-with="Save and continue" /></p>')
      end
    end

    context 'for a logged out user' do
      it 'outputs the continue button with a link to sign-up' do
        expect(
          html_output
        ).to eq('<p class="actions"><input type="submit" name="commit" value="Continue" class="button" data-disable-with="Continue" /><a href="/test/sign_up">Save and come back later</a></p>')
      end
    end
  end
end
