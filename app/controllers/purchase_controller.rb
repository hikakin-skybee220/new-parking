class PurchaseController < ApplicationController
  require 'payjp'
  before_action :authenticate_user!
  before_action :pay_alert ,except: :index

  def index
    @user = current_user    
    if @parking = Park.find_by(user_id: @user.id, finish_stamp: "no")  
      if @parking.finish_on
        if @user.card.present?
          card = Card.where(user_id: @user.id).first
          #Cardテーブルは前回記事で作成、テーブルからpayjpの顧客IDを検索                          
          Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
          #保管した顧客IDでpayjpから情報取得
          customer = Payjp::Customer.retrieve(card.customer_id)
          #保管したカードIDでpayjpから情報取得、カード情報表示のためインスタンス変数に代入
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
          # viewの記述を簡略化
          ## 有効期限'月'を定義
          @exp_month = @default_card_information.exp_month.to_s
          ## 有効期限'年'を定義
          @exp_year = @default_card_information.exp_year.to_s.slice(2,3)
        end   
      else
        redirect_to("")
        flash[:alert] = "利用を終了するを押してください"
      end
    else
      redirect_to("/purchase/history")
    end
  end

  def pay
    @user = current_user
    @path = Rails.application.routes.recognize_path(request.referer)
    Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']  
    if @path[:controller] == "purchase"
      @parking = Park.find_by(user_id: @user.id, finish_stamp: "no")
      @price = @parking.price
      if @user.card.present?
        # ログインユーザーがクレジットカード登録済みの場合の処理
        # ログインユーザーのクレジットカード情報を引っ張ってきます。
        @card = Card.find_by(user_id: @user.id)                   
        #登録したカードでの、クレジットカード決済処理
        charge = Payjp::Charge.create(
        # 商品(product)の値段を引っ張ってきて決済金額(amount)に入れる
        amount: @price,
        customer: Payjp::Customer.retrieve(@card.customer_id),
        currency: 'jpy'
        )
      else
        # ログインユーザーがクレジットカード登録されていない場合(Checkout機能による処理を行います)
        # APIの「Checkout」ライブラリによる決済処理の記述
        Payjp::Charge.create(
        amount: @price,
        card: params['payjp-token'], # フォームを送信すると作成・送信されてくるトークン
        currency: 'jpy'
        )
      end
      @purchase = Purchase.create(user_id: @user.id, no_reservation_id: @user.id, start_on: @parking.start_on, finish_on: @parking.finish_on, price: @price)
      @parking.finish_stamp = "yes"
      @parking.save
      redirect_to action: 'done'
    elsif @path[:controller] == "reserves"
      @reserve = Reserve.find_by(user_id: @user.id, price_stamp: "no")
      @price = @reserve.price
      if @user.card.present?
        @card = Card.find_by(user_id: @user.id)
        Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']             
        charge = Payjp::Charge.create(
        amount: @price,
        customer: Payjp::Customer.retrieve(@card.customer_id),
        currency: 'jpy'
        )
      else
        Payjp::Charge.create(
        amount: @price,
        card: params['payjp-token'], 
        currency: 'jpy'
        )
      end
      @purchase = Purchase.create(user_id: @user.id, reservation_id: @user.id, start_on: @reserve.start_on, finish_on: @reserve.finish_on, price: @price)
      @reserve.price_stamp = "yes"
      @reserve.save
      redirect_to controller: :reserves, action: :done
    end        
  end

  def done
    @user = current_user    
    @parking = Park.where(user_id: @user.id, finish_stamp: "yes").last
    @price = @parking.price
  end

  def history
    @histories = Purchase.where(user_id: current_user.id).order(start_on: :desc)
    @parking = Park.find_by(user_id: current_user.id, finish_stamp: "no")
    @reserve = Reserve.find_by(user_id: current_user.id, price_stamp: "no")
  end
end
