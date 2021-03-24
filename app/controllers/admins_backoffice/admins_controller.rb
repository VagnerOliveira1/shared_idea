class AdminsBackoffice::AdminsController < AdminsBackofficeController
  before_action :password_vefiry, only: [:update]
  before_action :set_admin, only: [:edit, :update, :destroy]

  def index
    @admins = Admin.all
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      redirect_to admins_backoffice_admins_path, notice: "Administrador criado com sucesso!"
    else
      render :new
    end
  end

  def edit;end

  def update
    if @admin.update(admin_params)
      redirect_to admins_backoffice_admins_path, notice: "Administrador atualizado com sucesso!"
    else
      render :edit
    end
  end


  def destroy

    binding.pry

    if @admin.destroy!
      redirect_to admins_backoffice_admins_path, notice: "Administrador excluído com sucesso!"
    else
      render :index
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
