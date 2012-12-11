class AdminsController < ApplicationController

  before_filter :require_admin

  def show
    @user = current_user
    @origins = Origin.find_all_cached
    @airports = Airport.find_all_cached
    @matches = Match.includes(:trip, :user).order("trips.time ASC, trips.id ASC, matches.time_created ASC")
    @unconfirmed = []
    #users = User.all(:conditions => {:confirmed => true}, :order => "id ASC")
    @user_count = User.where(:confirmed => true).count
    #booked = User.joins(:matches).order("id ASC")
    @unbooked = []
    @unbooked_count = @user_count - @matches.size
    #b = 0
    #a = 0
    #while a < booked.size
    #  while (a != (booked.size - 1)) && (booked[a].id == booked[a+1].id)
    #    a = a + 1
    #  end
    #  while booked[a].id.to_s != users[b].id.to_s
    #    @unbooked.push(users[b])
    #    puts booked[a].id.to_s + " " + users[b].id.to_s
    #    b = b + 1
    #  end
    #  b = b + 1
    #  a = a + 1
    #end
    #while b < users.size
    #  @unbooked.push(users[b])
    #  b = b + 1
    #end
    @future = Time.now + 60*60*36
    @solo = []
    @groups = []
    @grouped_count = 0
    cur = []
    0.upto(@matches.size - 2) do |i|
      if @matches[i].trip_id == @matches[i+1].trip_id
        @grouped_count = @grouped_count + 1
        cur.push(@matches[i])
      elsif cur.size == 0
        @solo.push(@matches[i])
      else
        @grouped_count = @grouped_count + 1
        cur.push(@matches[i])
        @groups.push(cur)
        cur = []
      end
    end
    if cur.size != 0
      @grouped_count = @grouped_count + 1
      cur.push(@matches[@matches.size - 1])
      @groups.push(cur)
    else
      @solo.push(@matches[@matches.size - 1])
    end
  end

  def create
    params[:trip_id] = params[:trip_id] || "0"
    params[:group_id] = params[:group_id] || "0"
    if params[:group_id] != "agg"
      if params[:trip_id] =~ /^[0-9]{7}$/ && params[:group_id] =~ /^[0-9]{7}$/
        @trip = Trip.find_by_id(params[:trip_id])
        if !@trip.nil?
          @mode = "group"
          @trip.group_id = params[:group_id]
          @trip.save(:validate => false)
          matches = Match.includes(:user).where(:trip_id => params[:trip_id]).order("matches.time_created ASC")
          emails = []
          matches.each do |m|
            emails.push(m.user.email)
          end
          email_string = emails.join(",")
          UserMailer.group_confirmation(email_string, matches, @trip, Origin.find_by_id_cached(@trip.origin_id)).deliver
          customer = Stripe::Customer.retrieve(matches.first.user.stripe_customer_id)
          if customer.account_balance > 0
            if matches.size > 1
              Stripe::Charge.create(
                :amount => customer.account_balance - 500,
                :currency => "usd",
                :customer => customer.id
              )
              UserMailer.booking_receipt(matches.first, customer.account_balance - 500, true).deliver
            else
              Stripe::Charge.create(
                :amount => customer.account_balance,
                :currency => "usd",
                :customer => customer.id
              )
              UserMailer.booking_receipt(matches.first, customer.account_balance, false).deliver
            end
            customer.account_balance = 0
            customer.save
          end
        else
          @error = "Could not find trip"
        end
      else
        @error = "Illegal input"
      end
    else
      params[:trip_id] = params[:trip_id] || "0"
      @trip = Trip.find_by_id(params[:trip_id])
      if !@trip.nil?
        @mode = "script"
        matches = Match.includes(:user).where(:trip_id => params[:trip_id]).order("matches.time_created ASC")
        @leader = matches.first.user
        @count = matches.size
        locations = [0, 6547, 6550, 11219, 11231]
        @origin = locations[@trip.origin_id] + @trip.airport_id
        if @trip.airport_id == 1
          @time = @trip.time + 60*(60*3 + 10)
        else
          @time = @trip.time + 60*(60*2.5 + 10)
        end
        @hour = @time.hour % 12
        if @hour == 0
          @hour = 12
        end
        @meridiem = (@time.hour > 11) ? "PM" : "AM"
      else
        @error = "Giveup"
      end
    end
    respond_to do |format|
      format.js
    end
  rescue Exception => e
    @error = e.message
    respond_to do |format|
      format.js
    end
  end
end
