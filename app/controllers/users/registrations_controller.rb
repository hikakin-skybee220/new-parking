# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end


  # POST /resource
  # def create
  #   super
  # end

  # def show
  #   @card = Card.where(user_id: current_user.id).first
  #   if @card.blank?      
  #   else
  #     Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
  #     customer = Payjp::Customer.retrieve(@card.customer_id)
  #     @default_card_information = customer.cards.retrieve(@card.card_id)

  #     ##カードのアイコン表示のための定義づけ
  #     @card_brand = @default_card_information.brand
  #     case @card_brand
  #     when "Visa"
  #       # 例えば、Pay.jpからとってきたカード情報の、ブランドが"Visa"だった場合は返り値として
  #       # (画像として登録されている)Visa.pngを返す
  #       @card_src = "logo_visa.gif"
  #     when "JCB"
  #       @card_src = "jcb.png"
  #     when "MasterCard"
  #       @card_src = "logo_mastercard.gif"
  #     when "American Express"
  #       @card_src = "american_express.png"
  #     when "Diners Club"
  #       @card_src = "diners_club.png"
  #     when "Discover"
  #       @card_src = "discover.png"
  #     end

  #     #  viewの記述を簡略化
  #     ## 有効期限'月'を定義
  #     @exp_month = @default_card_information.exp_month.to_s
  #     ## 有効期限'年'を定義
  #     @exp_year = @default_card_information.exp_year.to_s.slice(2,3)
  #   end
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    "/"
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
