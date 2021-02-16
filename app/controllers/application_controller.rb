class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception    

    
    def pay_alert
        if @current_user
            @non_pay_user = Park.find_by(user_id: @current_user.id , finish_stamp: "no")
            @non_pay_reserve_user = Reserve.find_by(user_id: @current_user.id , price_stamp: "no")
        end
    end
    
    def authenticate_user!
        @current_user = User.find_by(id: session[:user_id])
    end
    
    # def ensure_correct_user
    #     if params[:id] =! @current_user.id
    #         redirect_to("/")
    #         flash[:alert] = "権限がありません。"
    #     end
    # end
    
    
    include SessionsHelper  

    private                                                        
    # tokenが正規のものであれば、デコード結果を返す
    # そうでなければfalseを返す
    def authenticate_firebase_id_token
      # authenticate_with_http_tokenは、HTTPリクエストヘッダーに
      # Authorizationが含まれていればブロックを評価する。
      # 含まれていなければnilを返す。
      authenticate_with_http_token do |token, options|
        begin
          decoded_token = FirebaseHelper::Auth.verify_id_token(token)
        rescue => e
          logger.error(e.message)
          false
        end
      end
    end

    
end
