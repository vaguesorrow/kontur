# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
def create_users
  accounts = [
    ["admin@kontur.test", "Алина", "admin"],
    ["reader1@kontur.test", "Дана", "user"],
    ["reader2@kontur.test", "Амир", "user"],
    ["reader3@kontur.test", "Мария", "user"],
    ["reader4@kontur.test", "Тимур", "user"],
    ["reader5@kontur.test", "Анна", "user"]
  ]

  accounts.each do |email, name, role|
    user = User.find_or_initialize_by(email: email)
    user.role = role

    # Если подключён has_secure_password.
    if user.new_record? && user.respond_to?(:password=)
      user.password = "TestPassword123!"
    end

    user.save!

    Profile.find_or_create_by!(user_id: user.id) do |profile|
      profile.display_name = name
      profile.bio = role == "admin" ? "Редактор Контура" : "Читатель Контура"
    end

    puts "Пользователь: #{email}"
  end
end

def create_articles
  admin = User.find_by!(email: "admin@kontur.test")

  topics = [
    ["Как выбрать вуз", "Что сравнить перед подачей документов."],
    ["Способы поступления", "С чего начать изучение вариантов поступления."],
    ["Подготовка документов", "Как организовать подготовку документов."],
    ["Дедлайны поступления", "Как следить за сроками выбранного вуза."],
    ["Вступительные испытания", "Где искать программу и формат испытаний."],
    ["Общежитие", "Какие вопросы уточнить перед переездом."],
    ["Первые дни в университете", "Как подготовиться к началу учёбы."],
    ["Контакты приёмной комиссии", "Как сформулировать вопрос университету."],
    ["Студенческие сообщества", "Где искать общение и поддержку."],
    ["Как проверять информацию", "Как отличать актуальные правила от старых советов."]
  ]

  topics.each do |title, description|
    Article.find_or_create_by!(
      title: title,
      user_id: admin.id
    ) do |article|
      article.body = <<~TEXT
        #{description}

        Это демонстрационный материал для проверки сайта «Контур».

        Здесь появятся подробные объяснения, последовательность действий
        и ссылки на официальные источники.

        Условия и сроки необходимо уточнять на сайте выбранного вуза.
      TEXT
      article.published = true
    end

    puts "Статья: #{title}"
  end
end

def create_comments(quantity)
  admin = User.find_by!(email: "admin@kontur.test")
  readers = User.where(
    email: (1..5).map { |i| "reader#{i}@kontur.test" }
  ).to_a

  texts = [
    "Спасибо, теперь понятнее, с чего начать.",
    "Где можно посмотреть официальный источник?",
    "Хотелось бы подробнее узнать про документы.",
    "Будет ли отдельный материал про общежитие?",
    "Сохранила, вернусь перед подачей документов.",
    "Актуально ли это для следующего года?",
    "Можно добавить пример обращения в приёмную комиссию?",
    "Полезно было бы увидеть список шагов."
  ]

  Article.where(user_id: admin.id).find_each do |article|
    # Сохраняем уже созданные комментарии при повторном запуске.
    next if Comment.exists?(article_id: article.id)

    texts.sample(quantity.to_a.sample).each do |body|
      Comment.create!(
        user_id: readers.sample.id,
        article_id: article.id,
        body: body
      )
    end

    puts "Комментарии к статье: #{article.title}"
  end
end



def seed
  create_users
  create_articles
  create_comments(2..8)
end

seed