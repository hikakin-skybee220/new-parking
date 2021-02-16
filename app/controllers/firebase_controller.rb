class FirebaseController < ApplicationController
    def create
        if decoded_token = authenticate_firebase_id_token
          user = yield(decoded_token)
          session[:user_id] = user.id
          flash[:notice] = 'ログインしました。'
          redirect_to("/")
        else
          flash[:alert] = 'ログインできませんでした。'
          redirect_to("/login")
        end
      end
end
