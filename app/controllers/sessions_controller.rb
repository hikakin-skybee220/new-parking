class SessionsController < ApplicationController
  def new

  end

  def create
    @user = User.find_by(uid: params['user-uid-token'], email: params['user-email-token'])
    if @user
      session[:user_id] = @user.id
      redirect_to("/")
      flash[:notice] = "ログインしました。"
    else
      render("/")
      flash[:alert] = "ログインできませんでした。"
    end
  end

  def googlecreate
    super do |decoded_token|
      User.find_by(
          email: decoded_token['decoded_token'][:payload]['email'],
          uid:   decoded_token['uid']
      )
  end
  end

  def destroy
    session[:user_id] = nil
    redirect_to("/")
    flash[:notice] = "ログアウトしました。"
  end
end
