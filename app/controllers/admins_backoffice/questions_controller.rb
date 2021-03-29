class AdminsBackoffice::QuestionsController < AdminsBackofficeController
  before_action :set_question, only: [:edit, :update, :destroy]
  before_action :subjects_all, only: [:new, :edit]

  def index
    @questions = Question.includes(:subject).order(:content).page(params[:page])
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save!
      redirect_to admins_backoffice_questions_path, notice: "Questão criada com sucesso!"
    else
      render :new
    end
  end

  def edit;end

  def update
    if @question.update(question_params)
      redirect_to admins_backoffice_questions_path, notice: "Questão atualizada com sucesso!"
    else
      render :edit
    end
  end


  def destroy
    if @question.destroy!
      redirect_to admins_backoffice_questions_path, notice: "Questão excluída com sucesso!"
    else
      render :index
    end
  end


  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params_question = params.require(:question).permit(:content, :subject_id)
  end

  def subjects_all
    @subjects = Subject.all.order(:description)
  end

end
