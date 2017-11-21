module Steps
  module CourtOrders
    class HasOrdersForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :has_court_orders
    end
  end
end
