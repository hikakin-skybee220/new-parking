class ParkingController < ApplicationController
  def start
    @parking = Park.new
    @time = Time.current
    @timedisplay = Time.current.strftime('%Y年%m月%d日 %H:%M')
  end

  def create    
    params[:park][:start_on] = Time.current
    @parking = Park.new(params.require(:park).permit(:start_on, :finish_on_schedule))
    @parking.finish_stamp = "no"
    if current_user
      @parking.user_id = current_user.id
    end
    if @parking.save      
      redirect_to("/parking/confirmations")      
    else
      render("/parking/start")
    end
  end

  # def confirmations
  #   @parking = Park.find_by(user_id: current_user.id)
  #   max = 400
  #   min = 100
  #   if (@parking.finish_on_schedule - @parking.start_on )/3600 <= 1.0
  #     @price = 100
  #   elsif (@parking.finish_on_schedule - @parking.start_on )/3600 <= 2.0
  #     @price =200
  #   elsif (@parking.finish_on_schedule - @parking.start_on )/3600 <= 3.0
  #     @price =300
  #   else
  #     @price= 100
  #   end
  # end

  def confirmations
    @parking = Park.find_by(user_id:current_user.id)

    start = @parking.start_on
    finish = @parking.finish_on_schedule


    time = (finish - start)/3600
    n = time
    money = 0

    m = (n/24).floor + 1

    if (m > 1)
      for i in 1...m - 1 do
        n = n - 24
      end
    end
    
    

    if (n < 1)
      money = 100
    elsif (n < 2)
      money = 200
    elsif (n < 3)
      money = 300
    elsif (n< 24)
      money = 400    
    end

    money = money*m    

    @price = money


  end

  def finish
    @parking = Park.find_by(user_id: current_user.id, finish_stamp: "no")
    @parking.finish_on = Time.current
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
