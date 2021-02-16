class ReservesController < ApplicationController
  require "payjp"
  before_action :authenticate_user!
  before_action :pay_alert ,except: :show
  def new
    @reserve = Reserve.new
    if Reserve.find_by(user_id: @current_user.id, price_stamp: "no")
      redirect_to("/reserves/show")
      flash[:alert] = "支払いが完了していない予約があります。"
    end    
    @time = Time.current
    @timedisplay = Time.current.strftime('%Y年%m月%d日 %H:%M')

    @now_reserve_user = Reserve.find_by('start_on <= ? AND finish_on >= ?',@time, @time)
    @reserve_users = Reserve.where('start_on >= ?',@time).order(start_on: :asc)
  end

  def create
    @reserve = Reserve.new(params.require(:reserve).permit(:start_on, :finish_on))
    @reserve.price_stamp = "no"
    @reserve.user_id = @current_user.id    
    start = @reserve.start_on
    finish = @reserve.finish_on
    
    time = ((finish - start) / 3600).to_f
    n = time
    
    money = 0

    @time = time
    day = (time/24).floor + 1
    for i in 1...(day) do
    n = n - 24
    end

    if (n <= 1 && n > 0)
      money = 100
    elsif (n <= 2&& n > 1)
        money = 200
    elsif (n <= 3&& n > 2)
        money = 300
    elsif (n <= 24&& n > 3)
        money = 400
    end

    money = money + 400 * (day - 1)

    @price = money 

    @time = Time.current
    @timedisplay = Time.current.strftime('%Y年%m月%d日 %H:%M')

    @now_reserve_user = Reserve.find_by('start_on <= ? AND finish_on >= ?',@time, @time)
    @reserve_users = Reserve.where('start_on >= ?',@time).order(start_on: :asc)
    @reserve.price = @price
    if @reserve.save      
      redirect_to("/reserves/show")      
    else
      render("/reserves/new")
    end
  end

  def show
    @user = @current_user
    if @reserve = Reserve.find_by(user_id:@current_user.id , price_stamp: "no")
      start = @reserve.start_on
      finish = @reserve.finish_on
      
      time = ((finish - start) / 3600).to_f
      n = time
      
      money = 0

      @time = time
      day = (time/24).floor + 1
      for i in 1...(day) do
      n = n - 24
      end
      @n=n      

      if (n <= 1 && n > 0)
          money = 100
      elsif (n <= 2&& n > 1)
          money = 200
      elsif (n <= 3&& n > 2)
          money = 300
      elsif (n <= 24&& n > 3)
          money = 400
      end

      money = money + 400 * (day - 1)

      @price = money       
      @card = Card.where(user_id: @user.id).first
      if @card.present?        
        #Cardテーブルは前回記事で作成、テーブルからpayjpの顧客IDを検索                          
        Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
        #保管した顧客IDでpayjpから情報取得
        customer = Payjp::Customer.retrieve(@card.customer_id)
        #保管したカードIDでpayjpから情報取得、カード情報表示のためインスタンス変数に代入
        @default_card_information = customer.cards.retrieve(@card.card_id)  
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
      redirect_to("/purchase/history")
      flash[:alert] = "利用していません。"
    end
  end

  def done
    @user = @current_user    
    @reserve = Reserve.where(user_id: @user.id, price_stamp: "yes").last
    @price = @reserve.price
  end
end
