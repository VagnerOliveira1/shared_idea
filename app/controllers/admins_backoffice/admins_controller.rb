class AdminsBackoffice::AdminsController < AdminsBackofficeController
  before_action :password_vefiry, only: [:update]
  before_action :set_admin, only: [:edit, :update]

  def index
    @admins = Admin.all
  end

  def edit
  end

  def update
    if @admin.update(admin_params)
      redirect_to admins_backoffice_admins_path, notice: "Administrador atualizado com sucesso!"
    else
      render :edit
    end
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params_admin = params.require(:admin).permit(:email, :password, :password_confirmation)
  end

  def password_vefiry
    if params[:admin][:password].blank? && params[:admin][:password_confirmation].blank?
      params[:admin].extract!(:password, :password_confirmation)
    end
  end

end
