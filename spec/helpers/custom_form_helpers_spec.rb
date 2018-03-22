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

  describe '#continue_button' do
    let(:c100_application) { C100Application.new(status: :in_progress) }
    let(:builder) { described_class.new :applicant, Applicant.new, helper, {} }
    let(:html_output) { builder.continue_button }

    before do
      allow(helper).to receive(:current_c100_application).and_return(c100_application)
    end

    context 'no c100 application yet' do
      let(:c100_application) { nil }

      it 'outputs the continue button' do
        expect(
          html_output
        ).to eq('<div class="form-submit"><input type="submit" name="commit" value="Continue" class="button" data-disable-with="Continue" /></div>')
      end
    end

    context 'for an application in screening' do
      let(:c100_application) { C100Application.new(status: :screening) }

      it 'outputs the continue button' do
        expect(
          html_output
        ).to eq('<div class="form-submit"><input type="submit" name="commit" value="Continue" class="button" data-disable-with="Continue" /></div>')
      end
    end

    context 'for a logged in user' do
      before do
        allow(helper).to receive(:user_signed_in?).and_return(true)
      end

      it 'outputs the save and continue button' do
        expect(
          html_output
        ).to eq('<div class="form-submit"><input type="submit" name="commit" value="Save and continue" class="button" data-disable-with="Save and continue" /></div>')
      end
    end

    context 'for a logged out user' do
      it 'outputs the continue button with a link to sign-up' do
        expect(
          html_output
        ).to eq('<div class="form-submit"><input type="submit" name="commit" value="Continue" class="button" data-disable-with="Continue" /><a href="/test/sign_up" class="button button-secondary button-save-return">Save and come back later</a></div>')
      end
    end
  end

  describe '#single_check_box' do
    let(:c100_application) { C100Application.new }
    let(:builder) { described_class.new :c100_application, c100_application, helper, {} }
    let(:html_output) { builder.single_check_box(:declaration_made) }

    it 'outputs the check box' do
      expect(
        html_output
      ).to eq('<div class="multiple-choice single-cb"><input name="c100_application[declaration_made]" type="hidden" value="0" /><input type="checkbox" value="1" name="c100_application[declaration_made]" id="c100_application_declaration_made" /><label for="c100_application_declaration_made">Declaration made</label></div>')
    end
  end
end
