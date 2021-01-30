class HomeController < ApplicationController
  def index
    @time = Time.current
    @timedisplay = Time.current.strftime('%Y年%m月%d日 %H:%M')
  end
end
