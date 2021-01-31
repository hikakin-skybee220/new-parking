class HomeController < ApplicationController
  def index
    @time = Time.current
    @timedisplay = Time.current.strftime('%Y年%m月%d日 %H:%M')
    @parking = Park.where(user_id: current_user.id).last
  end
end
