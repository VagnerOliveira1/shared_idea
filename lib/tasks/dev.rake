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

  private

  def show_spinner(msg_start, msg_end = 'Concluído!!!')
    spinner = TTY::Spinner.new("[:spinner]#{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end

