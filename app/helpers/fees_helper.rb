module FeesHelper
  def fee_amount
    ActionController::Base.helpers.number_to_currency(
      Rails.configuration.x.court_fee.amount_in_pence / 100
    )
  end
end
