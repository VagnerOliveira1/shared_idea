namespace :dev do

  DEFAULT_PASSWORD = "12345678"
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando o DB...") {  %x(rails db:drop) }
      show_spinner("Criando o DB...") {   %x(rails db:create) }
      show_spinner("Migrando o DB...") {  %x(rails db:migrate) }
      show_spinner("Cadastrando o Admin Padrão...") { %x(rails dev:add_default_admin) }
      show_spinner("Cadastrando outros Admins...") { %x(rails dev:add_others_admins) }
      show_spinner("Cadastrando o User Padrão...") { %x(rails dev:add_default_user) }
      show_spinner("Cadastrando Assuntos Padrões...") { %x(rails dev:subjects) }
      show_spinner("Cadastrando Questões e Respostas...") { %x(rails dev:answers_and_questions) }

    else
      puts "Você não está em ambiente de desenvolvimento"
    end
  end

  desc " Adiciona o admin padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: "admin@admin.com",
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc " Adiciona outros Administradores"
  task add_others_admins: :environment do
    5.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc " Adiciona o Usuario padrão"
  task add_default_user: :environment do
    User.create!(
      email: "user@user.com",
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc " Adiciona Assuntos Padrões"
  task subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc " Adiciona Perguntas e Respostas"
  task answers_and_questions: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do |i|
        params = create_question_params(subject)
        answers_array = params[:question][:answers_attributes]
        add_answers(answers_array)
        selected_true_answer(answers_array)
        Question.create!(params[:question])
      end
    end
  end

  private

  def selected_true_answer(answers_array)
    index_with_true = rand(answers_array.size)
    answers_array[index_with_true] = create_answer_params(true)
  end


  def add_answers(answers_array = [] )
    rand(2..5).times do |q|
      answers_array.push(
        create_answer_params
      )
    end
  end


  def create_answer_params(correct = false)
    { description: Faker::Lorem.sentence, correct: correct }
  end

  def create_question_params(subject = Subeject.all.sample)
    { question: {
        content: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
        subject: subject,
        answers_attributes: []
      }
    }

  end

  def show_spinner(msg_start, msg_end = 'Concluído!!!')
    spinner = TTY::Spinner.new("[:spinner]#{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end

