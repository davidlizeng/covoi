ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "ridegrouped.com",
  :user_name => "noreply@ridegrouped.com",
  :password => "d1e5d1d01acd9cc2ab00b7cdaf7461c0",
  :authentication => "plain",
  :enable_starttls_auto => true
}
