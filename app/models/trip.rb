class Trip < ActiveRecord::Base
  attr_accessor :card_token, :hour, :minute, :meridiem, :date, :type
  has_many :matches
  has_many :users, :through => :matches
  #self.primary_key = :id
  set_primary_key :id
  validate :validate_trip

  def validate_trip
    errors.add(:origin_id, "is invalid") unless Origin.isValidOrigin?(origin_id.to_s)
    errors.add(:airport_id, "is invalid") unless airport_id.to_s =~ /^[1-2]$/
    if time
      errors.add(:time, "is invalid") unless time.in_time_zone.to_s =~ /^2013-08-(0[1-9]|1[0-9]|2[0-9]|3[0-1]) ([0-1][0-9]|2[0-3]):[0-5][0-9]:00 -0700$/
    else
      errors.add(:date, "is invalid") unless date.to_s =~ /^08\/(0[1-9]|1[0-9]|2[0-9]|3[0-1])\/2013$/
      errors.add(:time, "is invalid") unless hour.to_s =~ /^([1-9]|1[0-2])$/ && minute.to_s =~ /^[0-5][0-9]$/ && meridiem.to_s =~ /^(AM|PM)$/
      errors.add(:type, "is invalid") unless type.to_s =~ /^[1-2]$/
    end
  end

  def self.buildDateTime(trip)
    if trip.meridiem == "AM" && trip.hour == "12"
      trip.hour = "0"
    elsif trip.meridiem == "PM" && trip.hour != "12"
      trip.hour = ((trip.hour.to_i) + 12).to_s
    end
    time = Time.new(trip.date[6, 4], trip.date[0, 2], trip.date[3, 2], trip.hour, trip.minute, 0, "-07:00")
    if trip.type == "1"
      time -= 60*60*3
    else
      time -= 60*60*4
    end
    return time
  end

  def dateString
    time.in_time_zone.strftime("%B %-d, %Y")
  end

  def timeString
    time.in_time_zone.strftime("%I:%M %p")
  end
end
