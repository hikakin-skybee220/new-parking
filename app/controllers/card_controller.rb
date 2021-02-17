class CardController < ApplicationController
  require 'payjp'
  before_action :pay_alert
  before_action :authenticate_user!

  def new
    @card = Card.where(user_id: @current_user.id)
    redirect_to user_path if @card.exists?
  end

  def pay #payjpとCardのデータベース作成を実施します。
    Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
    if params['payjp-token']
      customer = Payjp::Customer.create(
      description: '登録テスト', #なくてもOK
      email: @current_user.email, #なくてもOK
      card: params['payjp-token'],
      metadata: {user_id: @current_user.id}
      ) #念の為metadataにuser_idを入れましたがなくてもOK
      @card = Card.new(user_id: @current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save        
        redirect_to("/user/#{@current_user.id}")
      else
        redirect_to action: "pay"
      end
    elsif params['payjp-token-for-new-account']
      customer = Payjp::Customer.create(
      description: '登録テスト', #なくてもOK
      email: @current_user.email, #なくてもOK
      card: params['payjp-token-for-new-account'],
      metadata: {user_id: @current_user.id}
      ) #念の為metadataにuser_idを入れましたがなくてもOK
      @card = Card.new(user_id: @current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to("/purchase/index")
      else
        redirect_to action: "pay"
      end
    elsif params['payjp-token-for-reservation']
      customer = Payjp::Customer.create(
      description: '登録テスト', #なくてもOK
      email: @current_user.email, #なくてもOK
      card: params['payjp-token-for-reservation'],
      metadata: {user_id: @current_user.id}
      ) #念の為metadataにuser_idを入れましたがなくてもOK
      @card = Card.new(user_id: @current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to("/reserves/show")
      else
        redirect_to action: "pay"
      end
    elsif params['payjp-token'].blank? && params[:commit]
      redirect_to action: "new", alert: "クレジットカードを登録できませんでした。"
    elsif params['payjp-token-for-new-account'].blank? && params[:new_account_commit]
      redirect_to  controller: :purchase, action: :index, alert: "クレジットカードを登録できませんでした。"
    elsif params['payjp-token-for-reservation'].blank? && params[:reservation_commit]
      redirect_to  controller: :reserves, action: :show, alert: "クレジットカードを登録できませんでした。"
    end
  end

  def delete #PayjpとCardデータベースを削除します
    card = Card.where(user_id: @current_user.id).first
    if card.blank?
      redirect_to action: "new"
    else
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(card.customer_id)
      customer.delete
      card.delete
      if card.destroy
        redirect_to("/")
        flash[:notice] = "削除しました。"
      else
        redirect_to user_path, alert: "削除できませんでした。"
      end
    end
      
  end

  def show #Cardのデータpayjpに送り情報を取り出します
    card = Card.where(user_id: @current_user.id).first
    if card.blank?
      redirect_to action: "new" 
    else
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(card.customer_id)
      @default_card_information = customer.cards.retrieve(card.card_id)

      ##カードのアイコン表示のための定義づけ
      @card_brand = @default_card_information.brand
      case @card_brand
      when "Visa"
        # 例えば、Pay.jpからとってきたカード情報の、ブランドが"Visa"だった場合は返り値として
        # (画像として登録されている)Visa.pngを返す
        @card_src = "logo_visa.gif"
      when "JCB"
        @card_src = "jcb.png"
      when "MasterCard"
        @card_src = "logo_mastercard.gif"
      when "American Express"
        @card_src = "american_express.png"
      when "Diners Club"
        @card_src = "diners_club.png"
      when "Discover"
        @card_src = "discover.png"
      end

      #  viewの記述を簡略化
      ## 有効期限'月'を定義
      @exp_month = @default_card_information.exp_month.to_s
      ## 有効期限'年'を定義
      @exp_year = @default_card_information.exp_year.to_s.slice(2,3)
    end
  end
end
