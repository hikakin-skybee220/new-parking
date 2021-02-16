class UserController < ApplicationController
    require "payjp"
    before_action :authenticate_user!
    before_action :pay_alert

    def new

    end

    def create
        @user = User.new(name: params[:name],email: params['user-email-token'], uid: params['user-uid-token'])        
        if @user.save            
            session[:user_id] = @user.id
            redirect_to("/")
            flash[:notice] = "アカウントが作成されました。"
        else
            redirect_to action: "new"
            flash[:alert] = "もう一度お願いします?。"
        end
    end

    def googlecreate        
        User.create(
            email: params['user-email-token'],
            uid: params['user-uid-token']
        )        
        redirect_to("/")
    end

    def show
        @card = Card.where(user_id: @current_user.id).first
        if @card.blank?      
        else
        Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
        customer = Payjp::Customer.retrieve(@card.customer_id)
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

        #  viewの記述を簡略化
        ## 有効期限'月'を定義
        @exp_month = @default_card_information.exp_month.to_s
        ## 有効期限'年'を定義
        @exp_year = @default_card_information.exp_year.to_s.slice(2,3)
        end
    end

    def update
        @user = User.find_by(id: @current_user.id)
        @user.name = params[:name]
        @user.email = params['user-email-token']
        if @user.save                        
            redirect_to("/user/#{@user.id}")
            flash[:notice] = "編集されました。"
        else
            render action: :edit
            flash[:alert] = "もう一度お願いします。"
        end
    end

    def edit
        @user = User.find_by(id: @current_user.id)
    end
    def destroy
        @user = User.find_by(id: @current_user.id)
        @user.destroy
        session[:user_id] = nil
        redirect_to("/")
        flash[:notice] = "アカウントを削除しました。"        
    end
end