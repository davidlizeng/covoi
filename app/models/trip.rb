class Trip < ActiveRecord::Base
  attr_accessor :card_token, :hour, :minute, :meridiem, :date
  has_many :users, :through => :matches
  set_primary_key :id  
  validate :validate_date_and_time

  def validate_date_and_time
    if time
      errors.add(:time, "is invalid.") unless time.in_time_zone.to_s =~ /^2012-12-(0[1-9]|1[0-5]) ([0-1][0-9]|2[0-3]):[0-5][0-9]:00 -0800$/
    else
      errors.add(:date, "is invalid.") unless date =~ /^12\/(0[1-9]|1[0-5])\/2012$/
      errors.add(:time, "is invalid.") unless hour =~ /^([1-9]|1[0-2])$/ && minute =~ /^[0-5][0-9]$/ && meridiem =~ /^(AM|PM)$/
    end
  end

  validates :origin_id, :format => { :with => /^[1-3]$/, :message => "is invalid." }
  validates :airport_id, :format => { :with => /^[1-3]$/, :message => "is invalid." }

  def self.buildDateTime(trip)
    if trip.meridiem == "AM" && trip.hour == "12"
      trip.hour = "0"
    elsif trip.meridiem == "PM" && trip.hour != "12"
      trip.hour = ((trip.hour.to_i) + 12).to_s
    end
    Time.new(trip.date[6, 4], trip.date[0, 2], trip.date[3, 2], trip.hour, trip.minute, 0, "-08:00") 
  end
 
end
