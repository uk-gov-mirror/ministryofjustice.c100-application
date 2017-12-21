require 'spec_helper'

RSpec.describe Steps::Application::WithoutNoticeForm do
  it_behaves_like 'a yes-no question form', attribute_name: :without_notice
end
