class CookiesController < ApplicationController
  include CookiesHelper
  def edit; end

  def update
    cookie_form.assign_attributes cookie_params.merge(seen: true)
    cookies['cookie_setting'] = cookie_form.to_json
    redirect_to cookies_path, flash: { cookie_success: "You've set your cookie preferences" }
  end

  def create
    cookie_form.assign_attributes cookie_params.merge(seen: true)
    cookies['cookie_setting'] = cookie_form.to_json
    redirect_to params.dig(:cookie, :return_path), flash: { cookie_banner_confirmation: t("cookie_banner.confirmation_message.#{cookie_form.usage}") }
  end

  private

  def cookie_params
    params.require(:cookie).permit(:usage)
  end
end
