class SessionsController < ApplicationController
  include ApplicationHelper
  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.has_password?(params[:session][:password])
  	  flash[:success] = "#{greet_user} #{user.name}, votre session est désormais active n'oubliez pas de détruire cette session dès que vous n'en avez plus besoin"
      sign_in user
      redirect_to user
  	else
      flash.now[:error] = "Combinaison 'E-mail' <-> 'Mot de passe' inconnue" # Not quite right!
      render 'new'
  	end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end