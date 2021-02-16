class ParkingController < ApplicationController
  before_action :authenticate_user!
  before_action :pay_alert
  def start
    if Park.find_by(user_id: @current_user.id, finish_stamp: "no")
      redirect_to("/purchase/history")
      flash[:alert] = "現在利用中です。"
    end
    @parking = Park.new
    @time = Time.current
    @timedisplay = Time.current.strftime('%Y年%m月%d日 %H:%M')

    not_parks = Reserve.where('start_on <= ? AND finish_on >= ?', @time, @time)
    flash[:notice] = "申し訳ありません。現在他の人が予約をしている時間帯のためご利用できません。" if not_parks.present?

    @now_reserve_user = Reserve.find_by('start_on <= ? AND finish_on >= ?',@time, @time)
    @reserve_users = Reserve.where('start_on >= ?',@time).order(start_on: :asc)
    

  end

  def create    
    params[:park][:start_on] = Time.current
    @parking = Park.new(params.require(:park).permit(:start_on, :finish_on_schedule))
    @parking.finish_stamp = "no"    
    @parking.user_id = @current_user.id    
    @time = Time.current
    @now_reserve_user = Reserve.find_by('start_on <= ? AND finish_on >= ?',@time, @time)
    @reserve_users = Reserve.where('start_on >= ?',@time).order(start_on: :asc)
    
    if @parking.save      
      redirect_to("/parking/confirmations")      
    else
      render("/parking/start")
    end
  end

  def confirmations
    if @parking = Park.find_by(user_id:@current_user.id , finish_stamp: "no")
      start = @parking.start_on
      finish = @parking.finish_on_schedule
      
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
      elsif (n <= 2)
          money = 200
      elsif (n <= 3)
          money = 300
      elsif (n <= 24)
          money = 400
      end

      money = money + 400 * (day - 1)

      @price = money 
    else
      redirect_to("/purchase/history")
      flash[:alert] = "利用していません。"
    end
  end

  def finish
    if @parking = Park.where(user_id: @current_user.id, finish_stamp: "no").last
      if @parking.finish_on.blank?
        @parking.finish_on = Time.current
        @parking.finish_on_schedule = @parking.finish_on
        start = @parking.start_on
        finish = @parking.finish_on
        
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
        elsif (n <= 2)
            money = 200
        elsif (n <= 3)
            money = 300
        elsif (n <= 24)
            money = 400
        end
    
        money = money + 400 * (day - 1)
        
        @price = money 
        @parking.price = @price
      end
    else
      redirect_to("/purchase/history")
      flash[:alert] = "利用していません。"
    end
    if @parking.save
      redirect_to("/purchase/index")
    else
      render("/")
      flash[:notice] = "もう1度最初からお願いします。"
    end
  end

  def how_user

  end
  def parking_create

  end
  def update

  end
end
