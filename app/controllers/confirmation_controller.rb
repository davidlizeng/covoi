class ConfirmationController < ApplicationController
  
  def new
    if !valid_otp?(params[:id], params[:otp])
      redirect_to root_url
    end
    @id = params[:id]
  end 
end
