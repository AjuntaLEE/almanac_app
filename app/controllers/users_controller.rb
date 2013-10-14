class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		flash[:success] = "Merci, si votre accréditation est valide vous serez bientot en mesure d'accéder au service"
  		redirect_to @user
    else
      flash.now[:error] = "Le formulaire en l'état actuel est incomplet ou certains champs sont invalides"
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

end
