class PurchaseController < ApplicationController
  require 'payjp'

  def index
    @user = current_user
    @parking = Park.find_by(user_id: @user.id, finish_stamp: "no")    
    if @parking.finish_stamp == "yes"
      redirect_to("/purchase/history")
    elsif @parking.finish_stamp == "no"
      if user_signed_in?        
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
            @card_src = "visa.gif"
          when "JCB"
            @card_src = "jcb.gif"
          when "MasterCard"
            @card_src = "master.png"
          when "American Express"
            @card_src = "amex.gif"
          when "Diners Club"
            @card_src = "diners.gif"
          when "Discover"
            @card_src = "discover.gif"
          end
          # viewの記述を簡略化
          ## 有効期限'月'を定義
          @exp_month = @default_card_information.exp_month.to_s
          ## 有効期限'年'を定義
          @exp_year = @default_card_information.exp_year.to_s.slice(2,3)
        end        
  
        if (@parking.finish_on_schedule - @parking.start_on )/3600 <= 1.0
          @price = 100
        elsif (@parking.finish_on_schedule - @parking.start_on )/3600 <= 2.0
          @price =200
        elsif (@parking.finish_on_schedule - @parking.start_on )/3600 <= 3.0
          @price =300
        else
          @price= 400
        end        
        @parking.price = @price
        @parking.save
      else
        redirect_to user_session_path, alert: "ログインしてください"
      end
    end
  end

  def pay
    @user = current_user
    @parking = Park.find_by(user_id: @user.id, finish_stamp: "no")
    @price = @parking.price

    if @user.card.present?
      # ログインユーザーがクレジットカード登録済みの場合の処理
      # ログインユーザーのクレジットカード情報を引っ張ってきます。
      @card = Card.find_by(user_id: @user.id)
      # 前前前回credentials.yml.encに記載したAPI秘密鍵を呼び出します。
      Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']     
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
    @purchase = Purchase.create(no_reservation_id: @user.id, start_on: @parking.start_on, finish_on: @parking.finish_on)
    @parking.finish_stamp = "yes"
    @parking.save
    redirect_to action: 'done'
  end

  def done
    @user = current_user    
    @parking = Park.where(user_id: @user.id, finish_stamp: "yes").last
    @price = @parking.price
  end

  def histroy
    
  end
end
