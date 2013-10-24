class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :accredited_user,   only: [:index]
  before_action :admin_user,     only: [:destroy, :promote, :demote, :accredit, :discredit]
  before_action :can_show,     only: [:show]

  def index
    @users = User.paginate(page: params[:page],:per_page => 25)
  end

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

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Votre profil à été édité avec succés"
      redirect_to @user
    else
      flash.now[:error] = "Votre profil n'a pas été édité car le formulaire en l'état actuel est incomplet ou certains champs sont invalides"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Utilisateur éffacé"
    redirect_to users_url
  end

  def demote
    @user = User.find(params[:id])
    @user.demote
    if @user.save(validate: false)
      flash[:success] = "Administrateur #{@user.name} rétrogradé Utilisateur"
    else
      flash.now[:error] = "La tentative de rétrogradation de #{@user.name} a échoué"
    end 
    redirect_to users_url
  end

  def promote
    @user = User.find(params[:id])
    @user.promote
    if @user.save(validate: false)
      flash[:success] = "Utilisateur #{@user.name} promu Administrateur"
    else
      flash.now[:error] = "La tentative de promotion de #{@user.name}a échoué"
    end
    redirect_to users_url
  end

  def accredit
    @user = User.find(params[:id])
    @user.accredit
    if @user.save(validate: false)
      flash[:success] = "Utilisateur #{@user.name} est désormais accrédité et peut accéder aux pages réservées"
    else
      flash.now[:error] = "La tentative d'accréditation de #{@user.name}a échoué"
    end
    redirect_to users_url
  end

  def discredit
    @user = User.find(params[:id])
    @user.discredit
    if @user.save(validate: false)
      flash[:success] = "L'accréditation de #{@user.name} a été suspendue, il n'aura plus accès aux pages réservées"
    else
      flash.now[:error] = "La suspension de l'accréditation de #{@user.name} a échoué"
    end 
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def can_show
      @user = User.find(params[:id])
      redirect_to(root_url) unless (current_user.accrediteduser? || current_user.admin? || current_user?(@user))
    end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def accredited_user
      redirect_to(root_url) unless (current_user.accrediteduser? || current_user.admin?)
    end

end
