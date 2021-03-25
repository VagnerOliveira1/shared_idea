class AdminsBackoffice::SubjectsController < AdminsBackofficeController
  before_action :set_subject, only: [:edit, :update, :destroy]

  def index
    @subjetcs = Subject.all.page(params[:page])
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(admin_params)
    if @subject.save
      redirect_to admins_backoffice_subjects_path, notice: "Administrador criado com sucesso!"
    else
      render :new
    end
  end

  def edit;end

  def update
    if @subject.update(subject_params)
      redirect_to admins_backoffice_subjects_path, notice: "Assunto atualizado com sucesso!"
    else
      render :edit
    end
  end


  def destroy
    if @subject.destroy!
      redirect_to admins_backoffice_subjects_path, notice: "Assunto excluído com sucesso!"
    else
      render :index
    end
  end


  private

  def set_subject
    @admin = Admin.find(params[:id])
  end

  def subject_params
    params_admin = params.require(:admin).permit(:description)
  end

end

