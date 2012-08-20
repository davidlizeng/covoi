class ConfirmationController < ApplicationController
  
  def new
    if !valid_token?(params[:id], params[:auth_token])
      redirect_to root_url
    end
    @id = params[:id]
  end 
end
