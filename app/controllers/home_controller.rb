class HomeController < ApplicationController
  before_action :pay_alert
  before_action :authenticate_user!
  def index
    @time = Time.current
    @timedisplay = Time.current.strftime('%Y年%m月%d日 %H:%M')
    if @current_user
      @parking = Park.where(user_id: @current_user.id).last
    end
  end
end
